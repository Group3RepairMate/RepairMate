//
//  SignUpView.swift
//  RepairMate_custLogin
//
//  Created by Arjun Roperia on 2023-05-23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    @State private var address: String = ""
    
    var body: some View {
        VStack{
            Text("User Registration")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("User Details")
                .font(.system(size: 24))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top,10)
            
            TextField("Full Name", text: $fullName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top,5)
            
            TextField("Address", text: $address)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top,5)
            
            Text("User Credentials")
                .font(.system(size: 24))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top,10)
            
            TextField("Email", text: $email)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top,5)
            
            SecureField("Set Password", text: $password)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top,5)
            
            Button(action: {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    UserDefaults.standard.set(email, forKey: "EMAIL")
                    UserDefaults.standard.set(fullName, forKey: "NAME")
                    UserDefaults.standard.set(address, forKey: "ADDRESS")
                    if let error = error {
                        print(error)
                        return
                    }
                    if let authResult = authResult {
                        print(authResult.user.uid)
                        withAnimation {
                            userID = authResult.user.uid
                        }
                        
                        
                        let db = Firestore.firestore()
                        let signupData: [String: Any] = [
                            "email": email,
                            "fullName": fullName,
                            "address": address
                        ]
                        db.collection("customers").document(email).setData(signupData) { error in
                            if let error = error {
                                print("Error storing signup details: \(error)")
                            } else {
                                print("Signup details stored successfully.")
                            }
                        }
                    }
                }
            }) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,30)
            }
            Spacer()
        }
        .padding()
    }
}
