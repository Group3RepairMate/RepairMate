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
        VStack {
            Spacer()
            
            Text("Mechanic Registration")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                
                TextField("Garage Name", text: $garageName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                
                TextField("Garage Address", text: $garageAddress)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                Text("Select Garage Booking Type")
                Picker(selection: $selectedBookingType, label: Text("Booking Type")) {
                    ForEach(0..<bookingTypes.count) { index in
                        Text(bookingTypes[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(.white)
                .padding()
                
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
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentShowingView = "login"
                    }
                }) {
                    Text("Already have an account?")
                        .foregroundColor(.gray.opacity(1.0))
                }
            }
            .padding()
            .background(Color.white)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}
