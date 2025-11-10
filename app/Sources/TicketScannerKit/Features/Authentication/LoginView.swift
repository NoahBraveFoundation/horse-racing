import ComposableArchitecture
import SwiftUI

public struct LoginView: View {
  @Bindable var store: StoreOf<AuthenticationFeature>

  public init(store: StoreOf<AuthenticationFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationView {
      VStack(spacing: 24) {
        // Logo/Title
        VStack(spacing: 8) {
          Image(systemName: "ticket.fill")
            .font(.system(size: 60))
            .foregroundColor(.brandGreen)

          Text("Ticket Scanner")
            .font(.largeTitle)
            .fontWeight(.bold)

          Text("NoahBRAVE Foundation")
            .font(.headline)
            .foregroundColor(.secondary)
        }
        .padding(.top, 40)

        Spacer()

        if store.isLinkSent {
          // Success state
          VStack(spacing: 16) {
            Image(systemName: "envelope.badge.fill")
              .font(.system(size: 60))
              .foregroundColor(.brandGreen)

            Text("Check Your Email")
              .font(.title2)
              .fontWeight(.bold)

            Text("We've sent a login link to")
              .foregroundColor(.secondary)

            Text(store.email)
              .fontWeight(.semibold)

            Text("Please check your email and tap the link to complete your login.")
              .multilineTextAlignment(.center)
              .foregroundColor(.secondary)
              .padding(.horizontal, 32)
          }
          .padding(.horizontal, 32)
        } else {
          // Login Form
          VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
              Text("Email")
                .font(.headline)

              TextField("Enter your email", text: $store.email.sending(\.emailChanged))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            }

            Button(action: {
              store.send(.sendMagicLinkTapped)
            }) {
              HStack {
                if store.isLoading {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(0.8)
                }
                Text(store.isLoading ? "Sending..." : "Send Login Link")
              }
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.brandGreen)
              .foregroundColor(.white)
              .cornerRadius(8)
            }
            .disabled(store.isLoading)
          }
          .padding(.horizontal, 32)
        }

        Spacer()

        // Error Message
        if let errorMessage = store.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
        }

        // Footer
        VStack(spacing: 8) {
          Text("Admin access required")
            .font(.caption)
            .foregroundColor(.secondary)

          Text("Contact your administrator for access")
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .padding(.bottom, 20)
      }
      .navigationBarHidden(true)
    }
  }
}

#Preview {
  LoginView(
    store: Store(initialState: AuthenticationFeature.State()) {
      AuthenticationFeature()
    }
  )
}
