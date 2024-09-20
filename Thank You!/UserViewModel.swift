//
//  UserViewModel.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var loginErrorMessage: String?

    func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                self.isLoggedIn = true
                completion(true, nil)
            }
        }
    }
}

