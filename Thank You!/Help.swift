//
//  Help.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Help: View {
    @State private var helpRequests = [HelpRequest]()
    @State private var isRequestingHelp = false
    
    var body: some View {
        NavigationStack {
            List(helpRequests) { request in
                VStack(alignment: .leading) {
                    Text(request.helpDescription)
                        .font(.headline)
                    Button(action: { requestToHelp(request) }) {
                        Text("Request to Help")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Help Requests")
            .onAppear {
                fetchHelpRequests()
            }
        }
    }
    
    // Fetch help requests from Firebase
    func fetchHelpRequests() {
        let db = Firestore.firestore()
        db.collection("helpRequests").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching help requests: \(error)")
            } else {
                helpRequests = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let helpDescription = data["helpDescription"] as? String ?? ""
                    return HelpRequest(id: document.documentID, userID: data["userID"] as? String ?? "", helpDescription: helpDescription)
                } ?? []
            }
        }
    }
    
    // Function to request to help
    func requestToHelp(_ request: HelpRequest) {
        // Notify the user who requested help (e.g., via Firebase messaging)
        // In this example, we'll simulate the notification by printing it to the console.
        print("Requested to help user: \(request.userID)")
        
        // Logic to add a chat with the user
        createChat(with: request.userID)
    }
    
    func createChat(with userID: String) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser?.uid ?? "anonymous"
        
        // Create a new chat or fetch an existing one
        db.collection("chats").addDocument(data: [
            "participants": [currentUserID, userID],
            "lastMessage": "",
            "timestamp": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error creating chat: \(error)")
            } else {
                print("Chat created successfully.")
            }
        }
    }
}

struct HelpRequest: Identifiable {
    let id: String
    let userID: String
    let helpDescription: String
}
