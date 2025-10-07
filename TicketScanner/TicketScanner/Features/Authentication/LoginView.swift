import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Logo/Title
                VStack(spacing: 8) {
                    Image(systemName: "ticket.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Ticket Scanner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("NoahBRAVE Foundation")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                        
                        SecureField("Enter your password", text: $store.password.sending(\.passwordChanged))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button(action: {
                        store.send(.loginButtonTapped)
                    }) {
                        HStack {
                            if store.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text("Login")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .disabled(store.isLoading)
                }
                .padding(.horizontal, 32)
                
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
