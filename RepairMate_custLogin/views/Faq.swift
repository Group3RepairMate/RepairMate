import SwiftUI

struct Faq: View {
    var body: some View {
        ScrollView {
            VStack{
                VStack(alignment: .center, spacing: 20){
                    Text("Frequently Asked Questions")
                        .font(.title)
                        .foregroundColor(Color("darkgray"))
                        .padding(.top, -10)
                        .frame(alignment: .center)
                        .fontWeight(.semibold)
                    Text("")
                    
                }
                VStack(alignment: .leading, spacing: 20){
                    Text("Q: How do I update my profile information?")
                        .font(.headline)
                    Text("A: To update your profile information, tap on the 'Edit' button in the top-right corner of the profile screen. You can then make changes to your name, email, and other details.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text("Q: Where can I view my order history?")
                        .font(.headline)
                    Text("A: To view your order history, tap on the 'View History' option under the 'Profile' section. This will show you a list of all your past orders.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text("Q: How can I reset my password?")
                        .font(.headline)
                    Text("A: To reset your password, tap on the 'Reset Password' option under the 'Profile' section. Follow the instructions to reset your password via email.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text("Q: How can I contact customer support?")
                        .font(.headline)
                    Text("A: To contact customer support, tap on the 'Contact Us' option under the 'Help & Support' section. You can reach out to us via phone or email.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            .padding()
        }
    }
}
