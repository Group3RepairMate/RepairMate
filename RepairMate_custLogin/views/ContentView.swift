import SwiftUI
import FirebaseAuth
import Firebase

struct ContentView: View {
    @AppStorage("uid") var userID : String = ""
    var body: some View {
        
        if userID ==  ""{
            AuthView()
        }
        else{
            TabView{
                Homescreen().tabItem{
                    Image(systemName: "house.fill")
                    
                    Text("Home")
                    
                }
                
                Viewhistory().tabItem{
                    Image(systemName: "text.book.closed")
                    Text("History")
                }
                
                Profile().tabItem{
                    Image(systemName: "person.2.circle.fill")
                    Text("Profile")
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
