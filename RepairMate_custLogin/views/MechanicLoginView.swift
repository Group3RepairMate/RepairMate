//
//  MechanicLoginView.swift
//  RepairMate
//
//  Created by Bhuvesh Aggarwal on 2023-06-06.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MechanicLoginView: View {
    @AppStorage("mechanicId") var mechanicId: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var currentShowingView: String
    @State private var linkselection: Int? = nil
    
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
                            print(authResult.user.uid)
                            withAnimation {
                                mechanicId = authResult.user.uid
                            }
                            
                            // Retrieve mechanic details from Firestore
                            let db = Firestore.firestore()
                            db.collection("mechanics").document(email).getDocument { document, error in
                                if let error = error {
                                    print("Error retrieving mechanic details: \(error)")
                                    return
                                }
                                
                                if let document = document, document.exists {
                                    let data = document.data()
                                    // Process mechanic details here
                                    if let email = data?["email"] as? String {
                                        print("Mechanic email: \(email)")
                                    }
                                    if let garageName = data?["garageName"] as? String {
                                        print("Garage Name: \(garageName)")
                                    }
                                    if let garageAddress = data?["garageAddress"] as? String {
                                        print("Garage Address: \(garageAddress)")
                                    }
                                    if let bookingType = data?["bookingType"] as? String {
                                        print("Booking Type: \(bookingType)")
                                    }
                                } else {
                                    print("Mechanic document does not exist")
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
                .background(Color("darkgray")
                )
                .cornerRadius(70)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.gray,lineWidth: 0)
                        .foregroundColor(.black)
                )
            }
        }
    }
}
