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
    @State private var resetPasswordSelection:Int? = nil
    @State private var fullName:String = ""
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
                    .background(Color.gray)
                    
                    NavigationLink(destination: MechanicHistory(), tag: 1, selection:self.$historyselection){}
                    NavigationLink(destination: ResetPassCustomer(), tag: 1, selection:self.$resetPasswordSelection){}
                    NavigationLink(destination: NotificationMechanic(), tag: 1, selection:self.$notificationselection){}
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
                            isSheetPresented.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.white)
                        }
                        .sheet(isPresented: $isSheetPresented) {
                            EditMechanic()
                        }
                    }
                }
            }
            .onAppear(){
                for i in garagehelper.garagelist{
                    if i.email == mechanicId{
                        fullName = i.name
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
