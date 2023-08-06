import SwiftUI

struct Privacy: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .foregroundColor(Color("darkgray"))
                    .padding(.top, -52)
                    .frame(alignment: .center)
                    .fontWeight(.semibold)

                Text("This privacy notice for We \"we,\" \"us,\" or \"our,\" describes how and why we might collect, store, use, and/or share \"process\" your information when you use our services  such as when youDownload and use our mobile application RepairMate, or any other application of ours that links to this privacy noticeEngage with us in other related ways, including any sales, marketing, or events\nQuestions or concerns? Reading this privacy notice will help you understand your privacy rights and choices. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at .com\nSUMMARY OF KEY POINTS\nThis summary provides key points from our privacy notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below to find the section you are looking for\nWhat personal information do we process? When you visit, use, or navigate our Services, we may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use. Learn more about personal information you disclose to us\nDo we process any sensitive personal information? We do not process sensitive personal information\nDo we receive any information from third parties? We do not receive any information from third parties\nHow do we process your information? We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent. We process your information only when we have a valid legal reason to do so. Learn more about how we process your information\nIn what situations and with which parties do we share personal information?\nWe may share information in specific situations and with specific third parties. Learn more about when and with whom we share your personal information\nWhat are your rights? Depending on where you are located geographically, the applicable privacy law may mean you have certain rights regarding your personal information. Learn more about your privacy rights")
                    .foregroundColor(.gray)
                    .font(.subheadline)

            }
            .padding()
        }
    }
}
