import Apollo
import ApolloAPI
import Foundation

final class ApolloClientService: @unchecked Sendable {
  static let shared = ApolloClientService()

  private let apollo: ApolloClient
  private var authToken: String?

  private init() {
    let url = URL(string: Constants.API.baseURL + "/graphql")!

    let store = ApolloStore()

    // Create custom interceptor provider that adds auth headers
    // Note: We pass self after initialization, the weak reference in the provider handles this safely
    let interceptorProvider = AuthInterceptorProvider(store: store, client: nil)

    let networkTransport = RequestChainNetworkTransport(
      interceptorProvider: interceptorProvider,
      endpointURL: url
    )

    self.apollo = ApolloClient(
      networkTransport: networkTransport,
      store: store
    )

    // Now set self on the interceptor provider after initialization
    interceptorProvider.client = self
  }

  func setAuthToken(_ token: String?) {
    authToken = token
  }

  func getAuthToken() -> String? {
    return authToken
  }

  func fetch<Query: GraphQLQuery>(
    query: Query,
    cachePolicy: CachePolicy = .returnCacheDataElseFetch
  ) async throws -> Query.Data {
    try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(query: query, cachePolicy: cachePolicy) { result in
        switch result {
        case .success(let graphQLResult):
          if let data = graphQLResult.data {
            nonisolated(unsafe) let unsafeData = data
            continuation.resume(returning: unsafeData)
          } else if let errors = graphQLResult.errors {
            continuation.resume(throwing: ApolloError.graphQLErrors(errors))
          } else {
            continuation.resume(throwing: ApolloError.unknown)
          }
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  func perform<Mutation: GraphQLMutation>(
    mutation: Mutation
  ) async throws -> Mutation.Data {
    try await withCheckedThrowingContinuation { continuation in
      apollo.perform(mutation: mutation) { result in
        switch result {
        case .success(let graphQLResult):
          if let data = graphQLResult.data {
            nonisolated(unsafe) let unsafeData = data
            continuation.resume(returning: unsafeData)
          } else if let errors = graphQLResult.errors {
            continuation.resume(throwing: ApolloError.graphQLErrors(errors))
          } else {
            continuation.resume(throwing: ApolloError.unknown)
          }
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

enum ApolloError: Error, LocalizedError {
  case graphQLErrors([GraphQLError])
  case unknown

  var errorDescription: String? {
    switch self {
    case .graphQLErrors(let errors):
      return errors.first?.message ?? "GraphQL error"
    case .unknown:
      return "Unknown error"
    }
  }
}

// MARK: - Auth Interceptor Provider

class AuthInterceptorProvider: DefaultInterceptorProvider {
  weak var client: ApolloClientService?

  init(store: ApolloStore, client: ApolloClientService?) {
    self.client = client
    super.init(store: store)
  }

  override func interceptors<Operation: GraphQLOperation>(for operation: Operation)
    -> [ApolloInterceptor]
  {
    var interceptors = super.interceptors(for: operation)
    interceptors.insert(AuthInterceptor(client: client), at: 0)
    return interceptors
  }
}

// MARK: - Auth Interceptor

class AuthInterceptor: ApolloInterceptor {
  private weak var client: ApolloClientService?

  init(client: ApolloClientService?) {
    self.client = client
  }

  public var id: String {
    return "AuthInterceptor"
  }

  func interceptAsync<Operation: GraphQLOperation>(
    chain: any RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, any Error>) -> Void
  ) {
    // Add client platform header to identify mobile requests
    request.addHeader(name: "X-Client-Platform", value: "ios")

    // Add auth token to request headers if available
    if let token = client?.getAuthToken() {
      request.addHeader(name: "Authorization", value: "Bearer \(token)")
    }

    chain.proceedAsync(
      request: request,
      response: response,
      interceptor: self,
      completion: completion
    )
  }
}
