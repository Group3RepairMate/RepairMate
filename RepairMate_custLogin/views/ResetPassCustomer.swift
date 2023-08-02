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
    @State private var isalert = false
    @State private var isshow = false
    @State private var ispass = false
    
    private func resetPassword() {
        let auth = Auth.auth()
        isalert = false
        isshow = false
        ispass = false

        if email != UserDefaults.standard.string(forKey: "EMAIL") {
            isalert = true
            isshow = true
            print("Please enter correct email.")
            return
        }
        if oldPass != UserDefaults.standard.string(forKey: "PASS") {
            isalert = true
            ispass = true
            print("Please enter correct password.")
            return
        } else {
            auth.sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    print(error)
                    return
                }
                isalert = true
                print("Password reset sent to email")
            }
        }
    }

    var body: some View {
        VStack(alignment: .center){
            Text("Reset Password")
                .font(.title)
                .foregroundColor(Color("darkgray"))
                .padding(.top, -10)
                .frame(alignment: .center)
            Text("")
            Text("")
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
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,20)
                    .padding(5)
            }
        
            .alert(isPresented: $isalert) {
                if isshow{
                    return Alert(
                        title: Text("Please check your email")
                    )
                }
                if ispass{
                    return Alert(
                        title: Text("Please check your password")
                    )
                    
                }
                return Alert(
                    title: Text("Password request sent successfully!")
                )
                
                
            }
          
        }
        
 
    }
}

struct ResetPassCustomer_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassCustomer()
    }
}
