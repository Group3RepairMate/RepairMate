import SwiftUI
import FirebaseAuth
import Firebase

struct Updateprofile: View {
    @State private var fullName: String = ""
    @State private var contact: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var linkselection: Int? = nil
    @State private var city: String = ""
    @State private var postal: String = ""
    @State private var street:String = ""
    @State private var name:String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("User Profile")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
                .padding(.top, 10)
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    Image(systemName: "person.fill")
                    Text("Name:")
                        .font(.title2)
                    Text(name)
                        .font(.title2)
                        .foregroundColor(Color("darkgray"))
                    
                }
                .padding(10)
                
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Email:")
                        .font(.title2)
                    Text("\(UserDefaults.standard.string(forKey: "EMAIL") ?? "")")
                        .font(.title2)
                        .foregroundColor(Color("darkgray"))
                }
                .padding(10)
                
                HStack {
                    Image(systemName: "house.fill")
                    Text("Street Name:")
                        .font(.title2)
                    Text(street)
                        .font(.title2)
                        .foregroundColor(Color("darkgray"))
                }
                .padding(10)
                
                HStack {
                    Image(systemName: "number")
                    Text("Postal Code:")
                        .font(.title2)
                    Text(postal) // Updated to use the Firebase value
                        .font(.title2)
                        .foregroundColor(Color("darkgray"))
                }
                .padding(10)
                
                HStack {
                    Image(systemName: "window.vertical.closed")
                    Text("City:")
                        .font(.title2)
                    Text(city) // Updated to use the Firebase value
                        .font(.title2)
                        .foregroundColor(Color("darkgray"))
                }
                .padding(10)
                
            }
            .onAppear {
                // Fetch the user profile from Firebase
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
                        street = data?["streetName"] as? String ?? ""
                        name = data?["fullName"] as? String ?? ""
                    } else {
                        print("User document does not exist")
                    }
                }
            }
            
            Spacer()
            
            NavigationLink(destination: Editview(), tag: 1, selection: self.$linkselection) { EmptyView() }
            
            Button(action: {
                self.linkselection = 1
            }) {
                Text("Edit Profile")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: 120)
                    .background(Color("darkgray"))
                    .cornerRadius(70)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .padding(20)
        .background(Color.white)
    }
}

struct Updateprofile_Previews: PreviewProvider {
    static var previews: some View {
        Updateprofile()
    }
}
