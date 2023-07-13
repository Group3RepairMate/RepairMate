
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct MechanicProfile: View {
    @AppStorage("mechanicId") var mechanicId: String = ""
    var body: some View {
        VStack{
          
            Button(action:{
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    withAnimation{
                        mechanicId = ""
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
        }
    }
}

struct MechanicProfile_Previews: PreviewProvider {
    static var previews: some View {
        MechanicProfile()
    }
}
