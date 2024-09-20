//
//  ChatMessage.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/18/24.
//

import SwiftUI
import FirebaseFirestore

struct ChatMessage: View {
    var chat: Chat
    @State private var messages = [Message]()
    @State private var newMessage = ""
    @State private var scrollToBottom = false

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messages) { message in
                        HStack {
                            if message.isFromCurrentUser {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                    Text(message.timestamp, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                VStack(alignment: .leading) {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                    Text(message.timestamp, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
                .onChange(of: messages.count) {
                    scrollToBottom = true
                }
                .onChange(of: scrollToBottom) {
                    if scrollToBottom {
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                        scrollToBottom = false
                    }
                }
            }

            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) {
                    Text("Send")
                        .foregroundColor(.blue)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .navigationTitle(chat.userName)
        .onAppear {
            fetchMessages()
        }
    }

    // Function to fetch messages in real-time from Firestore
    private func fetchMessages() {
        let db = Firestore.firestore()
        db.collection("chats").document(chat.id).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                } else {
                    messages = snapshot?.documents.compactMap { document in
                        let data = document.data()
                        let text = data["text"] as? String ?? ""
                        let isFromCurrentUser = data["isFromCurrentUser"] as? Bool ?? false
                        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        return Message(id: document.documentID, text: text, isFromCurrentUser: isFromCurrentUser, timestamp: timestamp)
                    } ?? []
                }
            }
    }

    // Function to send a message
    private func sendMessage() {
        let db = Firestore.firestore()
        let messageData: [String: Any] = [
            "text": newMessage,
            "isFromCurrentUser": true,
            "timestamp": Timestamp()
        ]
        
        db.collection("chats").document(chat.id).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                newMessage = ""
            }
        }
    }
}

// Updated Message Model with Timestamp
struct Message: Identifiable {
    let id: String
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date
}
