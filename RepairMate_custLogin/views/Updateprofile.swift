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
            Text("User Profile")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Name: \(UserDefaults.standard.string(forKey: "NAME") ?? "")")
                        .font(.title2)
                    
                }
                
                .padding(10)
                
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Email: \(UserDefaults.standard.string(forKey: "EMAIL") ?? "")")
                        .font(.title2)
                }
                .padding(10)
                
                HStack {
                    Image(systemName: "house.fill")
                    Text("Street Name: \(UserDefaults.standard.string(forKey: "ADDRESS") ?? "")")
                        .font(.title2)
                }
                .padding(10)
                HStack {
                    Image(systemName: "number")
                    Text("Postal Code: \(UserDefaults.standard.string(forKey: "POSTAL") ?? "")")
                        .font(.title2)
                }
                .padding(10)
                HStack {
                    Image(systemName: "window.vertical.closed")
                    Text("City: \(UserDefaults.standard.string(forKey: "CITY") ?? "")")
                        .font(.title2)
                }
                .padding(10)
                
            
            }
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 2)
         
            NavigationLink(destination: Editview(), tag: 1, selection:self.$linkselection){}
            Button(action: {
                self.linkselection = 1
            }) {
                Text("Edit Profile")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: 120)
                    .background(Color("darkgray"))
                    .cornerRadius(70)
            }
            
            Spacer()
        }

        .navigationBarTitle("", displayMode: .inline)
        .padding(20)
        .background(Color.white)
                    
    }
}

struct Updateprofile_Previews: PreviewProvider {
    static var previews: some View {
        Updateprofile()
    }
}
