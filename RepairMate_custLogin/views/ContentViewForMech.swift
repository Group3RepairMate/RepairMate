import SwiftUI

struct ContentViewForMech: View {
    @AppStorage("mechanicId") var mechanicId: String = ""
    var body: some View {
        
        if mechanicId ==  ""{
            Mauthview()
        }
        else{
            TabView{
                Mechanics_Home().tabItem{
                    Image(systemName: "house.fill")
                    
                    Text("Home")
                    
                }
                
                MechanicHistory().tabItem{
                    Image(systemName: "text.book.closed")
                    Text("History")
                }
                
                MechanicProfile().tabItem{
                    Image(systemName: "person.2.circle.fill")
                    Text("Profile")
                }
                
            }
         
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            
        }
    }
}

struct ContentViewForMech_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewForMech()
    }
}
