//
//  MechanicLoginView.swift
//  RepairMate
//
//  Created by Bhuvesh Aggarwal on 2023-06-06.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct MechanicLoginView: View {
    @AppStorage("mechanicId") var mechanicId: String = ""
    @AppStorage("mechanicPassword") var mechanicPassword: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var currentShowingView: String
    @State private var showingAlert = false
    @EnvironmentObject var garagehelper: Garagehelper
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.[a-z])(?=.[$@$#!%?&])(?=.[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Welcome back!")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .opacity(0.5)
                    TextField("Email", text: $email)
                    Spacer()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black,lineWidth: 1)
                )
                .padding(.top,5)
                
                HStack{
                    Image(systemName: "lock.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .opacity(0.5)
                    SecureField("Password", text: $password)
                    Spacer()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black,lineWidth: 1)
                )
                .padding(.top,5)
                
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            if(self.garagehelper.garagelist.isEmpty){
                                self.showingAlert = true
                            }
                            else{
                                var isMechanicPresent:Bool = false
                                for i in self.garagehelper.garagelist{
                                    if(email==i.email){
                                        isMechanicPresent = true
                                    }
                                }
                                
                                if(isMechanicPresent){
                                    UserDefaults.standard.set(email,forKey: "EMAIL")
                                    withAnimation{
                                        mechanicId = email
                                        mechanicPassword = password
                                        self.currentShowingView = "mechanichome"
                                    }
                                }
                                else{
                                    showingAlert = true
                                }
                            }
                        }
                    }
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("darkgray"))
                        .cornerRadius(8)
                        .padding(.top,20)
                }
                .alert(isPresented: $showingAlert){
                    Alert(title: Text("Alert"),
                          message: Text("User not found! \n Try again."),
                          dismissButton: .default(Text("OK")))
                }
                
                Button(action: {
                    withAnimation{
                        self.currentShowingView = "signup"
                    }
                }) {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .padding(.top,5)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
       
}
