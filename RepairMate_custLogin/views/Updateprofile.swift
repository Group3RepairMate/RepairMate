import SwiftUI
import FirebaseAuth
import Firebase

struct Updateprofile: View {
    @State private var fullName: String = ""
    @State private var streetName: String = ""
    @State private var postal: String = ""
    @State private var city: String = ""
    @State private var linkselection: Int? = nil
    @State private var showAlert = false
    @State private var show = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Edit Profile")
                .font(.title)
                .foregroundColor(Color("darkgray"))
                .fontWeight(.semibold)
                .padding(.top,-33)
            Text("")
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter Your Name")
                        .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.purple)
                            .font(.system(size: 20))
                            .opacity(0.5)
                        TextField("", text: $fullName)
                            .autocorrectionDisabled()
                        Spacer()
                    }
                    .padding(9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    Text("")
                    Text("Enter Your Street")
                        .font(.subheadline)
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                            .opacity(0.5)
                        TextField("", text: $streetName)
                            .autocorrectionDisabled()
                        Spacer()
                    }
                    .padding(9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    Text("")
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Enter Your Postal Code")
                            .font(.subheadline)
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                                .opacity(0.5)
                            TextField("", text: $postal)
                                .autocorrectionDisabled()
                            Spacer()
                        }
                        .padding(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        Text("")
                        Text("Enter Your City")
                            .font(.subheadline)
                        HStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(Color("darkgray"))
                                .font(.system(size: 20))
                                .opacity(0.5)
                            TextField("", text: $city)
                                .autocorrectionDisabled()
                            Spacer()
                        }
                        .padding(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        Text("")
                        
                        
                    }
                    
                }
                //                .padding(.horizontal, 9)
                .padding()
            }
            // .padding()
            Spacer()
            // .padding(.horizontal, 20)
            Button(action: {
                if fullName.isEmpty || streetName.isEmpty || postal.isEmpty || city.isEmpty {
                    show = true
                    showAlert = true
                } else {
                    let db = Firestore.firestore()
                    let userID = Auth.auth().currentUser?.uid
                    UserDefaults.standard.set(fullName, forKey: "NAME")
                    guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
                        print("User document ID not found")
                        return
                    }
                    
                    db.collection("customers").document(userDocumentID).updateData([
                        "fullName": fullName,
                        "streetName": streetName,
                        "cityName": city,
                        "postalCode": postal
                    ]) { error in
                        if let error = error {
                            print("Error updating user profile: \(error)")
                        } else {
                            print("User profile updated successfully.")
                            show = true
                            showSuccessAlert = true
                        }
                    }
                }
            }) {
                Text("Update")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,20)
                    .padding(5)
            }
            .alert(isPresented:$show){
                
                if (showSuccessAlert){
                    return Alert(
                        title: Text("Success"),
                        message: Text("Profile updated successfully."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                else{
                    return Alert(
                        title: Text("Error"),
                        message: Text("Please enter all the details."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            
        }
        .onAppear {
            let db = Firestore.firestore()
            let userID = Auth.auth().currentUser?.uid
            
            guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
                print("User document ID not found")
                return
            }
            
            db.collection("customers").document(userDocumentID).getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    city = data?["cityName"] as? String ?? ""
                    postal = data?["postalCode"] as? String ?? ""
                    streetName = data?["streetName"] as? String ?? ""
                    fullName = data?["fullName"] as? String ?? ""
                } else {
                    print("User document does not exist")
                }
            }
        }
        
    }
}

struct Updateprofile_Previews: PreviewProvider {
    static var previews: some View {
        Updateprofile()
    }
}
