//
//  NeedHelp.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NeedHelp: View {
    @State private var helpDescription = ""
    @State private var isSubmitting = false
    @State private var submissionSuccess = false
    @State private var submissionError: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Describe Your Need for Help")) {
                    TextEditor(text: $helpDescription)
                        .frame(height: 150)
                }
                
                if let error = submissionError {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Button(action: submitHelpRequest) {
                    Text("Submit Request")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(helpDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)
            }
            .navigationTitle("Need Help")
            .overlay(
                Group {
                    if isSubmitting {
                        ProgressView("Submitting...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            )
            .alert(isPresented: $submissionSuccess) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your help request has been submitted."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Submit request to Firebase
    func submitHelpRequest() {
        isSubmitting = true
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? "anonymous"
        
        let newHelpRequest: [String: Any] = [
            "userID": userID,
            "helpDescription": helpDescription,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("helpRequests").addDocument(data: newHelpRequest) { error in
            isSubmitting = false
            if let error = error {
                submissionError = "Error submitting help request: \(error.localizedDescription)"
            } else {
                submissionSuccess = true
                helpDescription = ""
            }
        }
    }
}
