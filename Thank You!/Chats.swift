//
//  Chats.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI
import FirebaseFirestore

struct Chats: View {
    @State private var chats = [Chat]()
    @State private var friendChats = [Chat]()
    @State private var nonFriendChats = [Chat]()
    @State private var isShowingFriends = true // Track whether the "Friends" tab is selected

    var body: some View {
        NavigationStack {
            VStack {
                // Buttons to toggle between Friends and Non-Friends
                HStack(spacing: 0) {
                    Button(action: {
                        isShowingFriends = true
                    }) {
                        Text("Friends")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8) // Thinner vertical padding
                            .background(isShowingFriends ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(isShowingFriends ? .white : .black)
                            .cornerRadius(0) // Remove corner radius if preferred
                    }
                    
                    Button(action: {
                        isShowingFriends = false
                    }) {
                        Text("Non-Friends")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8) // Thinner vertical padding
                            .background(!isShowingFriends ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(!isShowingFriends ? .white : .black)
                            .cornerRadius(0) // Remove corner radius if preferred
                    }
                }
                .padding(.horizontal) // Padding on the sides for the buttons

                // Spacer to push the chat list down
                Spacer()

                // List of chats
                if chats.isEmpty {
                    Text("No chats available.")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding()
                } else {
                    List(isShowingFriends ? friendChats : nonFriendChats) { chat in
                        NavigationLink(destination: ChatMessage(chat: chat)) {
                            chatRowView(chat: chat)
                        }
                    }
                }

                Spacer() // Another spacer to maintain consistent spacing
            }
            .navigationTitle("Chats")
            .onAppear {
                fetchChats()
            }
        }
    }

    // Function to fetch chats from Firestore
    private func fetchChats() {
        let db = Firestore.firestore()
        db.collection("chats").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching chats: \(error)")
            } else {
                chats = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let userName = data["userName"] as? String ?? "Unknown User"
                    let userImageURL = data["userImageURL"] as? String ?? ""
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let isFriend = data["isFriend"] as? Bool ?? false
                    return Chat(
                        id: document.documentID,
                        userName: userName,
                        userImageURL: userImageURL,
                        lastMessage: lastMessage,
                        isFriend: isFriend
                    )
                } ?? []

                // Separate into friends and non-friends
                friendChats = chats.filter { $0.isFriend }
                nonFriendChats = chats.filter { !$0.isFriend }
            }
        }
    }

    // Row view for a chat
    private func chatRowView(chat: Chat) -> some View {
        HStack {
            AsyncImage(url: URL(string: chat.userImageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(chat.userName)
                    .font(.headline)
                Text("Last message: \(chat.lastMessage)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

// Model for Chat
struct Chat: Identifiable {
    let id: String
    let userName: String
    let userImageURL: String
    let lastMessage: String
    let isFriend: Bool
}
