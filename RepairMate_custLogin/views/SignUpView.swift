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
        VStack {
            Text("Create an account!!")
                .foregroundColor(Color("darkgray"))
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.top,-50)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.blue)
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black,lineWidth: 1)
            )
            .padding(11)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Password", text: $password)
                
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black,lineWidth: 1)
            )
            .padding(11)
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.brown)
                TextField("Full Name", text: $fullName)
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black,lineWidth: 1)
            )
            .padding(11)
            
            HStack {
                Image(systemName: "house")
                    .foregroundColor(.purple)
                TextField("Street Name", text: $streetName)
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black,lineWidth: 1)
            )
            .padding(11)
            HStack {
                Image(systemName: "number")
                    .foregroundColor(.black)
                TextField("Postal Code", text: $postal)
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black,lineWidth: 1)
            )
            .padding(11)
            HStack {
                Image(systemName: "window.vertical.closed")
                    .foregroundColor(.orange)
                TextField("City Name", text: $city)
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black,lineWidth: 1)
            )
            .padding(11)
            
            Text("")
        
            
            Button(action: {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    UserDefaults.standard.set(email, forKey: "EMAIL")
                    UserDefaults.standard.set(password, forKey: "PASS")
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
            })  {
                Text("Create Account")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(10)
                    .padding(.top,10)
            }            }
        .navigationBarTitle("", displayMode: .inline)
        //.navigationBarHidden(true)
    }
}
