import SwiftUI
import FirebaseFirestore

struct NotificationScreen: View {
    @State private var orderList: [Order] = []
    @State private var timeList: [Timestamp] = []
    var body: some View {
        VStack(spacing: 16) {
            Text("New Notification")
                .font(.title)
                .bold()
            Text("\(orderList.count)")
            Text("You have a new message.")
                .font(.subheadline)
            
            List(orderList, id: \.id) { order in
                VStack() {
                    Text("Approval!! Your order is accepted by \(order.garageName) at \(formattedDateTime(_:timeList[0].dateValue())).")
                }
            }
        }
        .onAppear {
            fetchOrderList()
        }
    }
    
    private func fetchOrderList() {
        guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
            print("User document ID not found")
            return
        }
        
        Firestore.firestore().collection("customers").document(userDocumentID).collection("Orderlist").order(by: "dateTime", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving order list: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            let orders = documents.compactMap { order -> Order? in
                let data = order.data()
                let notifiedAt = data["updatedAt"] as? Timestamp
                let id = data["bookingID"] as? String ?? ""
                let fname = data["firstName"] as? String ?? ""
                let lname = data["lastName"] as? String ?? ""
                let contactNo = data["contactNumber"] as? String ?? ""
                let email = data["emailAddress"] as? String ?? ""
                let problem = data["problemDesc"] as? String ?? ""
                let apartment = data["apartmentNum"] as? String ?? ""
                let streetname = data["streetName"] as? String ?? ""
                let postalcode = data["postalcode"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let garage = data["garagename"] as? String ?? ""
                let status = data["status"] as? String ?? ""
                let date = data["dateTime"] as? Timestamp ?? Timestamp()
                let garageemail = data["garageemail"] as? String ?? ""
                let avalability = data["garageAvailability"] as? String ?? ""
                
                self.timeList.append(notifiedAt ?? Timestamp())
                
                return Order(bookingId: id,firstName: fname, lastName: lname, email: email, date: date.dateValue(), contactNo: contactNo, apartment:apartment,streetname:streetname,postalcode: postalcode,city: city, status: status, problemDisc: problem,garageemail: garageemail,garageName: garage,avalability: avalability)
            }
            
            for i in orders{
                if(i.status == "accepted"){
                    self.orderList.append(i)
                }
            }
        }
    }
    
    private func formattedDateTime(_ dateTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: dateTime)
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen()
    }
}
