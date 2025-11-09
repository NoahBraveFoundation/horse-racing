import Apollo
import ApolloAPI
import Foundation

final class ApolloClientService: @unchecked Sendable {
  static let shared = ApolloClientService()

  private let apollo: ApolloClient

  private init() {
    let url = URL(string: "https://horses.noahbrave.org/graphql")!

    let store = ApolloStore()
    let networkTransport = RequestChainNetworkTransport(
      interceptorProvider: DefaultInterceptorProvider(store: store),
      endpointURL: url
    )

    self.apollo = ApolloClient(
      networkTransport: networkTransport,
      store: store
    )
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
