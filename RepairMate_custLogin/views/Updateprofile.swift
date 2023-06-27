//
//  Updateprofile.swift
//  RepairmateHome
//
//  Created by Patel Chintan on 2023-06-07.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct Updateprofile: View {
    @State private var fullName:String = ""
    @State private var contact:String = ""
    @State private var email:String = ""
    @State private var address:String = ""
    var body: some View {
        VStack{
            Text("Update Profile")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
            TextField("Enter Your Name",text: $fullName)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)

            TextField("Enter Your Address",text: $address)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            Spacer()
            Button(action: {
                // Update the user's profile in the Repairmate collection
                let db = Firestore.firestore()
                let userID = Auth.auth().currentUser?.uid
                
                guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
                    print("User document ID not found")
                    return
                }
                
                db.collection("customers").document(userDocumentID).updateData([
                    "fullName": fullName,
                    "address": address
                ]) { error in
                    if let error = error {
                        print("Error updating user profile: \(error)")
                    } else {
                        print("User profile updated successfully.")
                    }
                }
                UserDefaults.standard.set(fullName, forKey: "NAME")
                UserDefaults.standard.set(address, forKey: "ADDRESS")
                
            }) {
                Text("Update")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(maxWidth: 120)
            }
            .background(Color("darkgray"))
            .cornerRadius(70)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue,lineWidth: 0)
                    .foregroundColor(.black)
            )


            
        }
        .padding(10)
    }
}

struct Updateprofile_Previews: PreviewProvider {
    static var previews: some View {
        Updateprofile()
    }
}
