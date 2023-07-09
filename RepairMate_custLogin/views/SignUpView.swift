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
    @State private var streetName: String = ""
    @State private var city: String = ""
    @State private var postal: String = ""
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Create an account!!")
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
                        .autocorrectionDisabled()
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
                        .autocorrectionDisabled()
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
                        .autocorrectionDisabled()
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
                    TextField("Street Name", text: $streetName)
                        .autocorrectionDisabled()
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
                    Image(systemName: "number")
                    TextField("Postal Code", text: $postal)
                        .autocorrectionDisabled()
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
                    Image(systemName: "window.vertical.closed")
                    TextField("City Name", text: $city)
                        .autocorrectionDisabled()
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
                        UserDefaults.standard.set(fullName, forKey: "NAME")
                        UserDefaults.standard.set(streetName, forKey: "ADDRESS")
                        UserDefaults.standard.set(city, forKey: "CITY")
                        UserDefaults.standard.set(postal, forKey: "POSTAL")

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
                                "streetName": streetName,
                                "cityName":city,
                                "postalCode":postal
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
            }
            Spacer()
            .navigationBarTitle("", displayMode: .inline)
            //.navigationBarHidden(true)
        }
    }
}
