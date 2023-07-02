
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
                HStack{
                    VStack(alignment: .leading, spacing: -1) {
                        if let image = selectedImage {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .alignmentGuide(.leading) { _ in -30 }
                                .padding(.top,15)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 90)
                                .foregroundColor(.white)
                                .alignmentGuide(.leading) { _ in -30 }
                                .padding(.top,15)
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
                    VStack{
                        Text("\(UserDefaults.standard.string(forKey: "NAME") ?? "")")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading,-59)
                            .padding(.top, -50)
                            .font(.system(size: 23))
                    }
                }
                .background(Color("darkgray"))
                
                NavigationLink(destination: Updateprofile(), tag: 1, selection:self.$linkselection){}
                NavigationLink(destination: Viewhistory(), tag: 1, selection:self.$historyselection){}
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
                        // Add action for "FAQ" button
                    }) {
                        Label("Privacy", systemImage: "checkmark.seal")
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
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        self.linkselection = 1
                    } label:{
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.white)
                    }
                    
                }
                
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
