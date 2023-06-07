
import SwiftUI

struct Homescreen: View {
    
    @State private var useremail:String = ""
    @State private var password:String = ""
    @State private var createaccount:Int? = nil
    @State private var homeview:Int? = nil
    @State var errormessage = false
    @State var isAlert = false
    @State private var searchlocation = ""
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            VStack {
                
                Text("Login")
                    .foregroundColor(.blue)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(10)
            
              Spacer()
        
//                Button(action:{
//                    self.createaccount = 1
//                })
//                {
//                    Text("SignUp")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(15)
//                        .frame(maxWidth: 120)
//                }
//                .background(Color.blue)
//                .cornerRadius(70)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 60)
//                        .stroke(Color.blue,lineWidth: 0)
//                        .foregroundColor(.black)
//                )
                
            }
            .searchable(text: $searchlocation)
            .autocorrectionDisabled()
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
