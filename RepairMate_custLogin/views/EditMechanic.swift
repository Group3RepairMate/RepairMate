//
//  EditMechanic.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-07-22.
//

import SwiftUI
import FirebaseAuth

struct EditMechanic: View {
    @State private var email: String = ""
    @State private var garageName: String = ""
    @State private var contactNo: String = ""
    @State private var garageAddress: String = ""
    @EnvironmentObject var garagehelper: Garagehelper
    @AppStorage("mechanicId") var mechanicId: String = ""
    @AppStorage("mechanicPassword") var mechanicPassword: String = ""
    var body: some View {
        VStack{
            Text("Edit Profile")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
            
            TextField("Enter Your Name",text: $garageName)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            
            TextField("Enter Your City",text: $email)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            
            TextField("Enter Your City",text: $contactNo)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            
            TextField("Enter Your Street",text: $garageAddress)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            
            Spacer()
            
            Button(action: {
                updateProfile()
            }) {
                Text("Update")
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
        .onAppear(){
            for i in garagehelper.garagelist{
                if(i.email == mechanicId){
                    garageName=i.name
                    email=i.email
                    contactNo=i.phone_no
                    garageAddress=i.location
                }
            }
        }
    }
    
    func updateProfile(){
        guard let url = URL(string: "http://localhost:8080/edit") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: String] = [
            "name": garageName,
            "email": email,
            "phone_no":contactNo,
            "location":garageAddress
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            else{
                DispatchQueue.main.async {
                    updateEmail()
                }
            }
        }.resume()
    }
    
    func updateEmail(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: mechanicId, password: mechanicPassword)
        
        user.reauthenticate(with: credential) { (result, error) in
            if let error = error {
                print(error)
            } else {
                user.updateEmail(to: email) { (error) in
                    if let error = error {
                        print(error)
                    } else {
                        mechanicId = email
                    }
                }
            }
        }
    }
}

struct EditMechanic_Previews: PreviewProvider {
    static var previews: some View {
        EditMechanic()
    }
}
