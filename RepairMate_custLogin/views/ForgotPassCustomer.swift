import SwiftUI
import Firebase

struct ForgotPassCustomer: View {
    @State private var email : String = ""
    
    private func forgotPassword(){
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: email){(error) in
            if let error = error {
                print(error)
                return
            }
            print("Password reset sent to email")
        }
    }
    var body: some View {
        VStack(alignment: .center){
            Text("Forgot Password")
                .font(.title)
                .foregroundColor(Color("darkgray"))
                .padding(.top, -10)
                .frame(alignment: .center)
                .fontWeight(.semibold)
            Text("")
            Text("")
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color("darkgray"))
                    .font(.system(size: 20))
                    .opacity(0.5)
                TextField("Enter Your Email", text: $email)
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding(9)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1)
            )
            
            Spacer()
            Button(action : {
                forgotPassword()
            }){
                Text("Forget Password")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,20)
                    .padding(5)
            }
       
        }
        
        .padding(10)
    }
}

struct ForgotPassCustomer_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassCustomer()
    }
}
