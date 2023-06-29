//
//  LoginView.swift
//  RepairMate_custLogin
//
//  Created by Arjun Roperia on 2023-05-22.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    @Binding var currentShowingView : String
    @AppStorage("uid") var userID : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var showingAlert = false
    @State private var forgotPass : Int? = nil
    private func isValidPassword(_ password : String) -> Bool{
        
        //atleast 6 characters Long
        //1 upper case letter
        //1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .foregroundColor(Color("darkgray"))
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack{
                    Image(systemName: "envelope")
                    TextField("Email", text: $email)
                    Spacer()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("darkgray"))
                )
                .padding()
                NavigationLink(destination: ForogotPassCustomer(), tag: 1, selection:self.$forgotPass){}
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    Spacer()
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("darkgray"))
                )
                .padding()
                Button(action : {
                    withAnimation{
                        self.forgotPass = 1
                    }
                }){
                    Text("Forgot Password")
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(5)
                }
                Button(action : {
                    withAnimation{
                        self.currentShowingView = "signup"
                    }
                }){
                    Text("Don't have an account?")
                        .foregroundColor(.gray.opacity(0.7))
                }
                Spacer()
                Button(action:{
                    Auth.auth().signIn(withEmail: email, password: password) { authResult,  error in
                        if let error = error{
                            print(error)
                            return
                        }
                        if let authResult = authResult{
                            let customersCollection = Firestore.firestore().collection("customers")
                            customersCollection.getDocuments { (snapshot, error) in
                                if let error = error {
                                    print("Error fetching customers: \(error.localizedDescription)")
                                    return
                                }
                                
                                guard let documents = snapshot?.documents else {
                                    print("No documents found in customers collection")
                                    return
                                }
                                var isCustomer:Bool = false
                                for document in documents {
                                    let customerId = document.documentID
                                    let customerData = document.data()
                                    if(customerData["email"] as! String==email){
                                        isCustomer = true
                                    }
                                }
                                if(isCustomer){
                                    UserDefaults.standard.set(email,forKey: "EMAIL")
                                    print(authResult.user.uid )
                                    withAnimation{
                                        userID = authResult.user.uid
                                    }
                                }
                                else{
                                    showingAlert = true
                                }
                            }
                        }
                    }
                })
                {
                    Text("SignIn")
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
                .alert("User not found", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                }
            }
        }
    }
}


