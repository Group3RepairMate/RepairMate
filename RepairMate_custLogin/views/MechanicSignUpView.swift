//
//  MechanicSignUpView.swift
//  RepairMate
//
//  Created by Bhuvesh Aggarwal on 2023-06-06.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MechanicSignUpView: View {
    @AppStorage("mechanicId") var mechanicId: String = ""
    @Binding var currentShowingView: String
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var garageName: String = ""
    @State private var garageAddress: String = ""
    @State private var selectedBookingType: Int = 0
    
    private let bookingTypes = ["Advance", "Immediate", "Both"]
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        VStack{
            Text("Garage Registration")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Section{
                Text("Garage Details")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top,10)
                
                TextField("Garage Name", text: $garageName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.top,5)
                
                TextField("Garage Address", text: $garageAddress)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.top,5)
                
                Text("Select your garage service frequency:")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top,10)
                Picker(selection: $selectedBookingType, label: Text("Booking Type")) {
                    ForEach(0..<bookingTypes.count) { index in
                        Text(bookingTypes[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top,1)
            }
            
            Section{
                Text("User Credentials")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top,15)
                
                TextField("Business Email", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.top,5)
                
                SecureField("Set Password", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.top,5)
            }
            
            Button(action: {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let authResult = authResult {
                        print(authResult.user.uid)
                        withAnimation {
                            mechanicId = authResult.user.uid
                        }
                        
                        // Store mechanic details in Firestore
                        let db = Firestore.firestore()
                        let mechanicData: [String: Any] = [
                            "email": email,
                            "garageName": garageName,
                            "garageAddress": garageAddress,
                            "bookingType": bookingTypes[selectedBookingType]
                        ]
                        db.collection("mechanics").document(authResult.user.uid).setData(mechanicData) { error in
                            if let error = error {
                                print("Error storing mechanic details: \(error)")
                            } else {
                                print("Mechanic details stored successfully.")
                            }
                        }
                    }
                }
            }) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,30)
            }
            
            Button(action: {
                withAnimation {
                    currentShowingView = "login"
                }
            }) {
                Text("Already have an account?")
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
