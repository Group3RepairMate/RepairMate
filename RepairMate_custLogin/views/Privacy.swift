import SwiftUI

struct Privacy: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .foregroundColor(Color("darkgray"))
                    .padding(.top, -10)
                    .frame(alignment: .center)

                Text("Your privacy is important to us. This Privacy Policy explains how we collect, use, and disclose your personal information when you use our app.")
                    .font(.headline)
                    .foregroundColor(.gray)

            }
            .padding()
        }
    }
}
