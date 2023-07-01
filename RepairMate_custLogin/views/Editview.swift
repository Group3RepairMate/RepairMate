//
//  Editview.swift
//  RepairMate
//
//  Created by Patel Chintan on 2023-06-16.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct Editview: View {
    @State private var fullName:String = UserDefaults.standard.string(forKey: "NAME") ?? ""
    @State private var contact:String = ""
    @State private var email:String = UserDefaults.standard.string(forKey: "EMAIL") ?? ""
    @State private var streetName:String = UserDefaults.standard.string(forKey: "ADDRESS") ?? ""
    @State private var city: String = UserDefaults.standard.string(forKey: "CITY") ?? ""
    @State private var postal: String = UserDefaults.standard.string(forKey: "POSTAL") ?? ""
    var body: some View {
      
        VStack{
            Text("Edit Profile")
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
            
            TextField("Enter Your Street",text: $streetName)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            TextField("Enter Your City",text: $city)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            TextField("Enter Your Postal Code",text: $postal)
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
                    "streetName": streetName,
                    "cityName":city,
                    "postalCode":postal
                ]) { error in
                    if let error = error {
                        print("Error updating user profile: \(error)")
                    } else {
                        print("User profile updated successfully.")
                    }
                }
                UserDefaults.standard.set(fullName, forKey: "NAME")
                UserDefaults.standard.set(streetName, forKey: "ADDRESS")
                UserDefaults.standard.set(city, forKey: "ADDRESS")
                UserDefaults.standard.set(postal, forKey: "POSTAL")
                
                
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
    
    struct Updateprofile_Previews: PreviewProvider {
        static var previews: some View {
            Updateprofile()
        }
    }
}

struct Editview_Previews: PreviewProvider {
    static var previews: some View {
        Editview()
    }
}
