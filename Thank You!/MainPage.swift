//
//  MainPage.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI
import FirebaseAuth

struct MainPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var isRegistering = false
    @State private var loginErrorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign In")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                if let loginErrorMessage = loginErrorMessage {
                    Text(loginErrorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                Button(action: loginUser) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Button(action: {
                    isRegistering = true
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                HomePage()
            }
            .navigationDestination(isPresented: $isRegistering) {
                RegisterView()
            }
        }
    }

    private func loginUser() {
        // Implement Firebase Auth sign-in logic
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                // If there's an error, display the error message
                loginErrorMessage = error.localizedDescription
            } else {
                // If successful, update the state to show the HomePage
                isLoggedIn = true
            }
        }
    }
}
#Preview {
    MainPage()
}
