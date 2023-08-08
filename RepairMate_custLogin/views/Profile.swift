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
    @State private var update:Int? = nil
    @State private var faq:Int? = nil
    @State private var contact:Int? = nil
    @State private var policy:Int? = nil
    @State private var contactus:Int? = nil
    @State private var fullName:String =   ""
    @State private var email:String = ""
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
                    VStack(alignment: .center, spacing: -1) {
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
                //                .background(Color("darkgray"))
                
                NavigationLink(destination: Updateprofile(), tag: 1, selection:self.$update){}
                NavigationLink(destination: Viewhistory(), tag: 1, selection:self.$historyselection){}
                NavigationLink(destination: ResetPassCustomer(), tag: 1, selection:self.$resetPasswordSelection){}
                NavigationLink(destination: NotificationScreen(), tag: 1, selection:self.$notificationselection){}
                NavigationLink(destination: Faq(), tag: 1, selection:self.$faq){}
                NavigationLink(destination: Privacy(), tag: 1, selection:self.$policy){}
                
                NavigationLink(destination: ContactUs(), tag: 1, selection:self.$contact){}
                List {
                    Section(header: Text("Profile")) {
                        Button(action: {
                            self.notificationselection = 1
                        }) {
                            HStack {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.red)
                                    .imageScale(.large)
                                Text("")
                                Text("Notifications")
                                    .foregroundColor(.black) 
                                    .font(.headline)
                            }
                            .padding(3)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 3)
                        
                        Button(action: {
                            // Add action for "reset password" button
                            self.resetPasswordSelection = 1
                        }) {
                            HStack {
                                Image(systemName: "key.horizontal.fill")
                                    .foregroundColor(.orange)
                                    .imageScale(.large)
                                Text("")
                                Text("Reset Password")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                            .padding(3)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 5)
                    }
                    
                    Section(header: Text("Help & Support")) {
                        Button(action: {
                            self.faq = 1
                        }) {
                            HStack {
                                Image(systemName: "person.fill.questionmark")
                                    .foregroundColor(.purple)
                                    .imageScale(.large)
                                Text("")
                                Text("FAQ")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                            .padding(3)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 3)
                        
                        Button(action: {
                            self.policy = 1
                        }) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(.blue)
                                    .imageScale(.large)
                                Text("")
                                Text("Privacy")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                            .padding(3)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 3)
                        
                        Button(action: {
                            self.contact = 1
                        }) {
                            HStack {
                                Image(systemName: "phone.circle.fill")
                                    .foregroundColor(.gray)
                                    .imageScale(.large)
                                Text("")
                                Text("Contact Us")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                            .padding(3)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 3)
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
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("darkgray"))
                        .cornerRadius(8)
                        .padding(.top,1)
                        .padding(5)
                }
                //                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.update = 1
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
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
                        email = data?["email"] as? String ?? ""
                        
                    } else {
                        print("User document does not exist")
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
