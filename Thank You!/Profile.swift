//
//  Profile.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI

struct Profile: View {
    // Default data for testing
    @State private var profilePictureURL: String = "https://example.com/profile.jpg" // Replace with an actual image URL if needed
    @State private var name: String = "John Doe"
    @State private var age: Int = 25
    @State private var zipCode: String = "12345"
    @State private var description: String = "Software Developer, loves hiking and playing guitar."
    @State private var email: String = "johndoe@example.com"
    
    var body: some View {
        VStack {
            // Profile picture
            AsyncImage(url: URL(string: profilePictureURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            
            // Name
            Text(name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            // Age and Zip Code
            Text("Age: \(age)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Zip Code: \(zipCode)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Email
            Text(email)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Description
            Text(description)
                .font(.body)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // Button to navigate to Settings
            NavigationLink(destination: Settings()) {
                Text("Go to Settings")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Profile")
    }
}

#Preview {
    Profile()
}

