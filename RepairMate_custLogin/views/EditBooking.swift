import SwiftUI
import FirebaseAuth
import Firebase


struct EditBooking: View {
    @State private var dateTime: Date = Date()
    @State private var location: String = ""
    @State private var showAlert:Bool = false
    var body: some View {
        VStack {
            Text("Edit Booking")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
                .padding(10)
            
//            NavigationLink(destination: Homescreen(), tag: 1, selection: self.$linkselection) {}
            
            Form {
                Section(header: Text("")) {
                    DatePicker("Date and Time", selection: $dateTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    
                    TextField("Address", text: $location)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                }
            }
            Button(action: {
                
                let db = Firestore.firestore()
                let userID = Auth.auth().currentUser?.uid
                
                guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else{
                    print("Not found")
                    return
                }
                
                let collectionRef = db.collection("customers")
                let documentRef = collectionRef.document(userDocumentID)
                let collectionRef2 = documentRef.collection("Orderlist")
                //let docID = collectionRef2.documentID
                collectionRef2.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else if let querySnapshot = querySnapshot {
                        // Iterate through the documents
                        for document in querySnapshot.documents {
                            // Retrieve the document ID
                            let documentID = document.documentID
                            db.collection("customers").document(userDocumentID).collection("Orderlist").document(documentID).updateData([
                                                        "dateTime": dateTime,
                                                        "address":location
                                                    ])
                                                { error in
                                                    if let error = error {
                                                        print("Error updating user profile: \(error)")
                                                    } else {
                                                        print("User profile updated successfully.")
                                                    }
                                                }
                        }
                    }
                }

 
                UserDefaults.standard.set(dateTime, forKey: "DATE")
                UserDefaults.standard.set(location, forKey: "ADDRESS")
                
                showAlert=true
                
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
            .alert(isPresented: $showAlert) {
                if showAlert {
                    return Alert(title: Text("Successful"), message: Text("Changes made"), dismissButton: .default(Text("OK")))
                    
                } else {
                    return Alert(title: Text("Failed"), message: Text("Cannot make the changes"), dismissButton: .default(Text("OK")))
                }
            }


            
        }
        .padding(10)
        }

}
    struct EditBooking_Previews: PreviewProvider {
        static var previews: some View {
            EditBooking()
        }
    }
