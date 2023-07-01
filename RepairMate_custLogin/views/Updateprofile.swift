import SwiftUI
import FirebaseAuth
import Firebase

struct Updateprofile: View {
    @State private var fullName: String = ""
    @State private var contact: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var linkselection: Int? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("logo")
            
            Text("User Profile")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Name\(UserDefaults.standard.string(forKey: "NAME") ?? "")")
                }
                .padding(.vertical, 8)
                
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Email\(UserDefaults.standard.string(forKey: "EMAIL") ?? "")")
                }
                .padding(.vertical, 8)
                
                HStack {
                    Image(systemName: "house.fill")
                    Text("Address\(UserDefaults.standard.string(forKey: "ADDRESS") ?? "")")
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

            .padding(.vertical, 20)
            
            Spacer()
            
            Button(action: {
                self.linkselection = 1
            }) {
                Text("Edit Profile")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: 120)
                    .background(Color.blue)
                    .cornerRadius(70)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
    }
}

struct Updateprofile_Previews: PreviewProvider {
    static var previews: some View {
        Updateprofile()
    }
}
