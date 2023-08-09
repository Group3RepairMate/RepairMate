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
                        .padding(.vertical, 3)
                    }
                    .listStyle(GroupedListStyle())
                    
                    
                    Button(action:{
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            UserDefaults.standard.removeObject(forKey: "MEMAIL")
                            UserDefaults.standard.removeObject(forKey: "MPASS")
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
    }
    
    
}


struct MechanicProfile_Previews: PreviewProvider {
    static var previews: some View {
        MechanicProfile()
    }
}
