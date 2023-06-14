//
//  SignUpView.swift
//  RepairMate_custLogin
//
//  Created by Arjun Roperia on 2023-05-23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @Binding var currentShowingView : String
    @AppStorage("uid") var userID : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    
    private func isValidPassword(_ password : String) -> Bool{
        
        //atleast 6 characters Long
        //1 upper case letter
        //1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")

        return passwordRegex.evaluate(with: password)
    }
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("Create an account!")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack{
                    Image(systemName: "mail" )
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    if(email.count != 0){
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                   
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    
                    Spacer()
                    
                    if(password.count != 0){
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                   
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding()
                
                Button(action : {
                    withAnimation{
                        self.currentShowingView = "login"
                    }
                }){
                    Text("Already have an account ?")
                        .foregroundColor(.gray.opacity(1.0))
                }
                Spacer()
                Spacer()
                
                Button{
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        UserDefaults.standard.set(email,forKey: "EMAIL")
                        if let error = error{
                            print(error)
                            return 
                        }
                        
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            withAnimation{
                                userID = authResult.user.uid
                            }
                        }
                    }
                    
                } label: {
                    Text("Create Account")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth : .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius:10)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
            }
            .preferredColorScheme(.dark)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}


