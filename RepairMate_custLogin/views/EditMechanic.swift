

import SwiftUI
import FirebaseAuth

struct EditMechanic: View {
    @Environment(\.dismiss) var dismiss
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
                .font(.title)
                .padding(15)
            
            Form{
                
                Section(header: Text("Garage Name:")) {
                    TextField("Enter Your Name",text: $garageName)
                        .padding(2)
                }
                
                Section(header: Text("Email:")) {
                    TextField("Enter Your City",text: $email)
                        .padding(2)
                }
                
                Section(header: Text("Contact No:")) {
                    TextField("Enter Your Name",text: $contactNo)
                        .padding(2)
                }
                
                Section(header: Text("Garage Address:")) {
                    TextField("Enter Your Name",text: $garageAddress)
                        .padding(2)
                }
            }
            
            Spacer()
            
            Button(action: {
                updateProfile()
                for i in garagehelper.garagelist{
                    if(i.email==mechanicId){
                        print(i.phone_no)
                    }
                }
            }) {
                Text("Update")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(8)
                    .padding()
            }
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: String] = [
            "name": garageName,
            "oldEmail":mechanicId,
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
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }.resume()
    }
}

struct EditMechanic_Previews: PreviewProvider {
    static var previews: some View {
        EditMechanic()
    }
}
