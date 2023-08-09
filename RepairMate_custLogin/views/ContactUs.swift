import SwiftUI

struct ContactUs: View {
    var body: some View {
        VStack(alignment:.center) {
            
            Text("Contact Us")
                .font(.title)
                .foregroundColor(Color("darkgray"))
                .padding(.top, -52)
                .frame(alignment: .center)
                .fontWeight(.semibold)
            Text("")
            Text("")
            Text("")
            Image("Image")
                .resizable()
                .frame( height: 320.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
            
            VStack(alignment: .leading, spacing: 20) {
                Text("")
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.blue)
                    Text("Phone:")
                        .fontWeight(.semibold)
                        .font(.title2)
                    
                    Text("123-456-7890")
                        .font(.title2)
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text("Email:")
                        .fontWeight(.semibold)
                        .font(.title2)
                
                    Text("repairmate@gmail.com")
                        .font(.title2)
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    Text("Address:")
                        .fontWeight(.semibold)
                        .font(.title2)
              
                    Text("George Brown College")
                        .font(.title2)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
    }
}

struct ContactUs_Previews: PreviewProvider {
    static var previews: some View {
        ContactUs()
    }
}
