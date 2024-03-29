import SwiftUI
import FirebaseFirestore

struct NotificationScreen: View {
    @State private var notifications: [Notify] = []

    var body: some View {
        VStack {
            Text("Notifications")
                .font(.title)
                .foregroundColor(Color("darkgray"))
                .padding(.top, -39)
                .frame(alignment: .center)
                .fontWeight(.semibold)
            
            List(notifications, id: \.id) { item in
                NavigationLink(destination: Notification(notification: item)) {
                    VStack {
                        Text(item.name)
                          .foregroundColor(.gray)
                          .fontWeight(.semibold)
                          .font(.system(size: 15))
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear(){
            notifications=[]
            fetchNotifications()
        }
    }
    
    func fetchNotifications() {
        var list: [[String:Any]]
        guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
            print("User document ID not found")
            return
        }
        
        Firestore.firestore().collection("notifications").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching customers: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found in customers collection")
                return
            }
            
            let list = documents.compactMap { noti -> Notify? in
                let data = noti.data()
                let name = data["name"] as? String ?? ""
                let from = data["from"] as? String ?? ""
                let to = data["to"] as? String ?? ""
                let msg = data["msg"] as? String ?? ""
                let date = data["date"] as? Date ?? Date.now
                return Notify(name: name, from: from, to: to, msg: msg, date: date)
            }
            for i in list{
                if(i.to == userDocumentID){
                    self.notifications.append(i)
                }
            }
        }
    }
    
    func formattedDateTime(_ dateTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: dateTime)
    }
}
