//
//  MechanicProfile.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-07-09.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct MechanicProfile: View {
    @State private var selectedImage: Data?
    @State private var isShowingImagePicker = false
    @State private var historyselection:Int? = nil
    @State private var notificationselection:Int? = nil
    @State private var mechanicedit:Int? = nil
    @State private var resetPasswordSelection:Int? = nil
    @State private var fullName:String = ""
    @State private var email:String = ""
    @State private var isSheetPresented = false
    @AppStorage("mechanicId") var mechanicId: String = ""
    @AppStorage("mechanicPassword") var mechanicPassword: String = ""
    @EnvironmentObject var garagehelper: Garagehelper
    
    
    var selectedUIImage: UIImage? {
        if let imageData = selectedImage {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var body: some View {
        if mechanicId == "" {
            AuthView()
        }
        else{
            NavigationView {
                VStack {
                    HStack {
                 
                        VStack {
                            Text(fullName)
                                .foregroundColor(Color("darkgray"))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 22.5))
                                .fontWeight(.semibold)
                            Text("")
                            
                            Text(email)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                                .font(.system(size: 22.5))
                          
                            Text("")
                        }
                    }
                    
                    NavigationLink(destination: MechanicHistory(), tag: 1, selection:self.$historyselection){}
                    NavigationLink(destination: ResetPassCustomer(), tag: 1, selection:self.$resetPasswordSelection){}
                    NavigationLink(destination: NotificationMechanic(), tag: 1, selection:self.$notificationselection){}
                    NavigationLink(destination: EditMechanic(), tag: 1, selection:self.$mechanicedit){}
                    List {

                        Button(action: {
                            self.notificationselection = 1
                        }) {
                            HStack {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.red) // Change symbol color
                                    .imageScale(.large)
                                Text("")
                                Text("Notifications")
                                    .foregroundColor(.black) // Font color
                                    .font(.headline)
                            }
                            .padding(3)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 3)
                        
                        Button(action: {
                            self.resetPasswordSelection = 1
                        }) {
                            HStack {
                                Image(systemName: "key.horizontal.fill")
                                    .foregroundColor(.orange) // Change symbol color
                                    .imageScale(.large)
                                Text("")
                                Text("Reset Password")
                                    .foregroundColor(.black) // Font color
                                    .font(.headline)
                            }
                            .padding(3)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 3)
                    }
                    .listStyle(GroupedListStyle())
                    
                    
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
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("darkgray"))
                            .cornerRadius(8)
                            .padding()
                    }
                    Spacer()
                }
                
                .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.mechanicedit = 1
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.black)
                        }
//                        .sheet(isPresented: $isSheetPresented) {
//                            EditMechanic()
//                        }
                    }
                }
            }
            .onAppear(){
                for i in garagehelper.garagelist{
                    if i.email == mechanicId{
                        fullName = i.name
                        email = i.email
                    }
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
                    let userRef = db.collection("customers").document(mechanicId) // Using userID directly here
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

struct MechanicProfile_Previews: PreviewProvider {
    static var previews: some View {
        MechanicProfile()
    }
}
