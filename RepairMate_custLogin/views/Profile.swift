
import SwiftUI
import FirebaseAuth

struct Profile: View {
    @State private var selectedImage: Image?
    @State private var isShowingImagePicker = false
    @State private var linkselection:Int? = nil
    @State private var historyselection:Int? = nil
    @AppStorage("uid") var userID : String = ""
    var body: some View {
        if userID ==  ""{
            AuthView()
        }
        NavigationView(){
            VStack {
                if let image = selectedImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 190)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 190)
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    Text("Edit")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(Color("darkgray"))
                        .cornerRadius(10)
                        .frame(width: 180)
                }
                .padding()
                
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadimage) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                NavigationLink(destination: Updateprofile(), tag: 1, selection:self.$linkselection){}
                NavigationLink(destination: Viewhistory(), tag: 1, selection:self.$historyselection){}
                List {
                    
                    Button(action: {
                        self.linkselection = 1
                    }) {
                        Text("Update Profile")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        self.historyselection = 1
                    }) {
                        Text("View History")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .cornerRadius(20)
                    }
                    
                    .listStyle(GroupedListStyle())
                }
                
                Button(action:{
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        withAnimation{
                            userID = ""
                        }
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
                
                
            }
        }
    }
    func loadimage(){
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
