
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
         
            TabView{
                Homescreen().tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                Autoparts().tabItem{
                    Image(systemName: "key.horizontal.fill")
                    Text("Autoparts")
                }
                
                Profile().tabItem{
                    Image(systemName: "person.2.circle.fill")
                    Text("Profile")
                }
            }
            .accentColor(.blue)
            .background(.red)
        }//NavigationView ends
    }//body ends
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

