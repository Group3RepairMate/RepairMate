//
//  MechanicSignUpView.swift
//  RepairMate
//
//  Created by Bhuvesh Aggarwal on 2023-06-06.
//

import SwiftUI
import FirebaseAuth

struct MechanicSignUpView: View {
    @Binding var currentShowingView : String
    @AppStorage("mechanicId") var mechanicId : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    
    private func isValidPassword(_ password : String) -> Bool{
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("Mechanic Registration")
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
                        self.currentShowingView = "mechanic_login"
                    }
                }){
                    Text("Already have an account ?")
                        .foregroundColor(.gray.opacity(1.0))
                }
                Spacer()
                Spacer()
                
                Button{
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error{
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            withAnimation{
                                mechanicId = authResult.user.uid
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
        }
    }
}

struct MechanicSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        MechanicSignUpView(currentShowingView: .constant("mechanic_signup"))
    }
}
