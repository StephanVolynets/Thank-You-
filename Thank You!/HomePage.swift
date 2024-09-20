//
//  HomePage.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI

struct HomePage: View {
    @State private var profileImage: UIImage? = UIImage(systemName: "person.circle.fill") // Default image for testing

    var body: some View {
        NavigationStack {
            TabView {
                Help()
                    .tabItem {
                        Label("Help", systemImage: "questionmark.circle")
                    }
                
                NeedHelp()
                    .tabItem {
                        Label("Need Help", systemImage: "exclamationmark.circle")
                    }
                
                Chats()
                    .tabItem {
                        Label("Chats", systemImage: "message")
                    }
            }
            .navigationTitle("Thank You!") // Set the title normally
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Profile()) {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle")
                                .font(.title)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
