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
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var currentShowingView: String
    //@State private var linkselection: Int? = nil
    @State private var showingAlert = false
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
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
                        let mechanicCollection = Firestore.firestore().collection("mechanics")
                        mechanicCollection.getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error fetching customers: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let documents = snapshot?.documents else {
                                print("No documents found in customers collection")
                                return
                            }
                            
                            if(!documents.isEmpty){
                                var isMechanic:Bool = false
                                for document in documents {
                                    let mechanicData = document.data()
                                    if(mechanicData["email"] as! String==email){
                                        isMechanic = true
                                    }
                                }
                                
                                if(isMechanic){
                                    UserDefaults.standard.set(email,forKey: "EMAIL")
                                    print(authResult.user.uid )
                                    withAnimation{
                                        mechanicId = authResult.user.uid
                                    }
                                }
                                else{
                                    showingAlert = true
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
    }
}
