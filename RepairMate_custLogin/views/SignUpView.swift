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
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    var body: some View {
        ZStack{
            
            VStack{
                HStack{
                    Text("Create an account!")
                        .foregroundColor(Color("darkgray"))
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

                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    
                    Spacer()
                    
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
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
                
                Button(action:{
                    
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
                    
                }
                )
                {
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
                        .stroke(Color.gray,lineWidth: 0)
                        .foregroundColor(.black)
                )
                
            }
  
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}


