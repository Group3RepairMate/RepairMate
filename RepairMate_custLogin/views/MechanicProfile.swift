//
//  MechanicProfile.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-07-09.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MechanicProfile: View {
    @AppStorage("mechanicId") var mechanicId: String = ""
    
    var body: some View {
        if mechanicId == "" {
            AuthView()
        }
        else{
            Button(action:{
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    withAnimation{
                        mechanicId = ""
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            })
            {
                Text("Logout")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(maxWidth: 120)
            }
            .background(Color("darkgray"))
            .cornerRadius(70)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue,lineWidth: 0)
                    .foregroundColor(.black)
            )
        }
    }
}

struct MechanicProfile_Previews: PreviewProvider {
    static var previews: some View {
        MechanicProfile()
    }
}
