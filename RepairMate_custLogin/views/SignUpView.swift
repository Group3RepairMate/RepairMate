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
        ZStack {
            VStack {
                HStack {
                    Text("Create an account!")
                        .foregroundColor(Color("darkgray"))
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email", text: $email)
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("darkgray"))
                )
                .padding()
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("darkgray"))
                )
                .padding()
                
                HStack {
                    Image(systemName: "person")
                    TextField("Full Name", text: $fullName)
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("darkgray"))
                )
                .padding()
                
                HStack {
                    Image(systemName: "house")
                    TextField("Address", text: $address)
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("darkgray"))
                )
                .padding()
                Spacer()
                Button(action: {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        UserDefaults.standard.set(email, forKey: "EMAIL")
                        UserDefaults.standard.set(password,forKey: "PASSWORD")
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
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(15)
                        .frame(maxWidth: 180)
                }
                .background(Color("darkgray"))
                .cornerRadius(70)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.gray, lineWidth: 0)
                        .foregroundColor(.black)
                )
                
            }
            Spacer()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}
