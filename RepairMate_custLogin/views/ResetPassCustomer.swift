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
            VStack{
                Text("Reset Password")
                    .font(.title)
                    .foregroundColor(Color("darkgray"))
                    .padding(.top, -52)
                    .frame(alignment: .center)
                    .fontWeight(.semibold)
                Text("")
                Text("")
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color("darkgray"))
                        .font(.system(size: 20))
                        .opacity(0.5)
                    TextField("Enter Your Email", text: $email)
                        .autocorrectionDisabled()
                    Spacer()
                }
                .padding(9)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
              //  .padding()
                Text("")
                Text("")
                HStack {
                    Image(systemName: "eye")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                        .opacity(0.5)
                    SecureField("Enter Your Old Password", text: $oldPass)
                        .autocorrectionDisabled()
                    Spacer()
                }
                .padding(9)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
//                .padding(.horizontal, 9)
            }
            .padding()
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
