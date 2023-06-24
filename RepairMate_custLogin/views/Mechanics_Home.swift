//
//  Mechanics_Home.swift
//  RepairMate
//
//  Created by Patel Chintan on 2023-06-24.
//

import SwiftUI
import FirebaseAuth

struct Mechanics_Home: View {
    @AppStorage("mechanicId") var mechanicId: String = ""
    var body: some View {
        if mechanicId ==  ""{
            Mauthview()
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
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

struct Mechanics_Home_Previews: PreviewProvider {
    static var previews: some View {
        Mechanics_Home()
    }
}
