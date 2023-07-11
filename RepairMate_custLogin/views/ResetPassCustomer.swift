//
//  ResetPassCustomer.swift
//  RepairMate
//
//  Created by Arjun Roperia on 2023-06-28.
//

import SwiftUI
import Firebase

struct ResetPassCustomer: View {
    @State private var email : String = ""
    @State private var oldPass : String = ""
    private func resetPassword(){
        let auth = Auth.auth()
        if oldPass != UserDefaults.standard.string(forKey: "PASSWORD"){
            print("Password does not match.")
            return
        }else{
            auth.sendPasswordReset(withEmail: email){(error) in
                if let error = error{
                    print(error)
                    return
                }
                
                print("Password reset sent to email")
            }
        }
        
    }
    var body: some View {
        VStack(alignment: .center){
            Text("Reset Password")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
                .padding()
            TextField("Enter Your Email Address",text: $email)
                .padding(15)
                .frame(width: 350.0)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(10)
            TextField("Enter Your Old password",text: $oldPass)
                .padding(15)
                .frame(width: 350.0)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(10)
            Spacer()
            Button(action : {
                resetPassword()
            }){
                Text("Reset Password")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(12)
                    .frame(maxWidth: 190)
            }
            .background(Color("darkgray"))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue,lineWidth: 0)
                    .foregroundColor(.black)
            )
        }
        
        .padding(10)
    }
}

struct ResetPassCustomer_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassCustomer()
    }
}
