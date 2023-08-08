import SwiftUI

struct Notification: View {
    var notification: Notify
    
    var body: some View {
        Text("\(notification.from)")
            .font(.title2)
            .foregroundColor(Color("darkgray"))
            .padding(.top, -37)
            .frame(alignment: .center)
            .fontWeight(.semibold)

        VStack(alignment: .center, spacing: 8) {
                Text("")
            Text(notification.msg)
                .foregroundColor(.black)
                .font(.body)
                .background(Color.white)
                .padding()
            Spacer()
        }
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
        
        .padding()
      
       
    }
}
