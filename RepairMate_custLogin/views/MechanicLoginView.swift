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
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Mechanic Login")
                        .font(.largeTitle)
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
                
                Button(action: {
                    withAnimation{
                        self.currentShowingView = "signup"
                    }
                }) {
                    Text("Don't have an account?")
                        .foregroundColor(.black.opacity(0.7))
                }
                Spacer()
                Spacer()
                
                Button {
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
                } label: {
                    Text("Sign In")
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
