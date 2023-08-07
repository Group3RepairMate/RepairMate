
import SwiftUI

struct SplashScreenView: View {
  
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if self.isActive {
                
                RoleSelectionView()
            } else {
                VStack {
                    Text("REPAIRMATE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color("darkgray"))
                    
                    Text("Welcome to our service!")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding()
                        .foregroundColor(Color("darkgray"))
                    
                    
                    Image("wrench")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 200)
//                        .background(Color("darkgray"))
                        .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }

    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
