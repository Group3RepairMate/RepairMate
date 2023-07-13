import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct Profile: View {
    @State private var selectedImage: Data?
    @State private var isShowingImagePicker = false
    @State private var linkselection: Int? = nil
    @State private var historyselection:Int? = nil
    @State private var notificationselection:Int? = nil
    @State private var resetPasswordSelection:Int? = nil
    @State private var fullName:String = ""
    @AppStorage("uid") var userID: String = ""
    
    var selectedUIImage: UIImage? {
        if let imageData = selectedImage {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var body: some View {
        if userID == "" {
            AuthView()
        }
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: -1) {
                        if let uiImage = selectedUIImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .alignmentGuide(.leading) { _ in -30 }
                                .padding(.top, 15)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 90)
                                .foregroundColor(.white)
                                .alignmentGuide(.leading) { _ in -30 }
                                .padding(.top, 15)
                        }
                        
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            Text("Edit")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                                .padding()
                                .cornerRadius(10)
                                .bold()
                            
                        }
                        .padding(.leading, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadimage) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                    }
                    VStack {
                        Text(fullName)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, -59)
                            .padding(.top, -50)
                            .font(.system(size: 23))
                    }
                }
                .background(Color("darkgray"))
                
                NavigationLink(destination: Updateprofile(), tag: 1, selection:self.$linkselection){}
                NavigationLink(destination: Viewhistory(), tag: 1, selection:self.$historyselection){}
                NavigationLink(destination: ResetPassCustomer(), tag: 1, selection:self.$resetPasswordSelection){}
                NavigationLink(destination: NotificationScreen(), tag: 1, selection:self.$notificationselection){}
                List {
                    Button(action: {
                        self.historyselection = 1
                    }) {
                        Label("View History", systemImage: "text.book.closed")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        // Add action for "FAQ" button
                    }) {
                        Label("FAQ", systemImage: "questionmark.circle")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .cornerRadius(20)
                    }
                    Button(action: {
                        self.notificationselection = 1
                    }) {
                        Label("Notifications", systemImage: "text.book.closed")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .cornerRadius(20)
                    }
                    Button(action: {
                        // Add action for "reset password" button
                        self.resetPasswordSelection = 1
                    }) {
                        Label("Reset password", systemImage: "key.horizontal.fill")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .cornerRadius(20)
                    }
                }
                .listStyle(GroupedListStyle())
                
                
                Button(action:{
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        withAnimation{
                            userID = ""
                        }
                        UserDefaults.standard.removeObject(forKey: "EMAIL")
                        UserDefaults.standard.removeObject(forKey: "NAME")
                        UserDefaults.standard.removeObject(forKey: "ADDRESS")
                        UserDefaults.standard.removeObject(forKey:"CITY")
                        UserDefaults.standard.removeObject(forKey:"POSTAL")
                        
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
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.linkselection = 1
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.white)
                    }
                }
            }
        }
            .onAppear(){
                let db = Firestore.firestore()
                let userID = Auth.auth().currentUser?.uid
             
                guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
                    print("User document ID not found")
                    return
                }
                
                db.collection("customers").document(userDocumentID).getDocument { document, error in
                    if let document = document, document.exists {
                        let data = document.data()
                        fullName = data?["fullName"] as? String ?? ""
                    } else {
                        print("User document does not exist")
                    }
                }
            }
        
    }
    
    func loadimage() {
        guard let uiImage = selectedUIImage,
              let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            print("Error converting image to data.")
            return
        }
        
        // Create a unique file name for the image
        let imageFileName = UUID().uuidString
        
        // Create a reference to the Firebase Storage bucket
        let storageRef = Storage.storage().reference().child("profileImages/\(imageFileName).jpeg")
        
        // Upload the image data to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            // Retrieve the download URL of the uploaded image
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error retrieving download URL: \(error.localizedDescription)")
                    return
                }
                
                if let imageUrl = url?.absoluteString {
                    // Store the image URL in Firestore
                    let db = Firestore.firestore()
                    let userRef = db.collection("customers").document(userID) // Using userID directly here
                    userRef.updateData(["profileImageUrl": imageUrl]) { (error) in
                        if let error = error {
                            print("Error updating profile image URL: \(error.localizedDescription)")
                        } else {
                            print("Profile image URL updated successfully.")
                        }
                    }
                }
            }
        }
    }
    
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
