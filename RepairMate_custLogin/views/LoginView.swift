
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
                .padding()
                NavigationLink(destination: ForgotPassCustomer(), tag: 1, selection:self.$forgotPass){}
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
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("darkgray"))
                        .cornerRadius(8)
                        .padding(.top,20)
                }
                .alert("User not found", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                
                Button(action : {
                    withAnimation{
                        self.currentShowingView = "signup"
                    }
                }){
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
        }
    }
}
