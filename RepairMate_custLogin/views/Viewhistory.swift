import SwiftUI
import FirebaseFirestore

struct Viewhistory: View {
    @State private var orderList: [History] = []
    enum Status {
        case processing
        case done
        case undone
        case all
    }
    
    @State private var status: Status = .all
    
    var body: some View {
        VStack {
            Text("Booking History")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
            
            if orderList.isEmpty {
                Text("No orders found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                
                Picker("Service", selection: $status) {
                    Text("All").tag(Viewhistory.Status.all)
                    Text("Processing").tag(Viewhistory.Status.processing)
                    Text("Done").tag(Viewhistory.Status.done)
                    Text("Pending").tag(Viewhistory.Status.undone)
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List(orderList, id: \.id) { order in
                    VStack(alignment: .leading) {
                        Text("\(order.garagename)")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                        Text("")
                        Text("Date and Time: \(formattedDateTime(order.dateTime))")
                            .font(.system(size: 14))
                        
                    }
                    .padding()
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
            
            let orders = documents.compactMap { document -> History? in
                let data = document.data()
                let location = data["location"] as? String ?? ""
                let timestamp = data["dateTime"] as? Timestamp ?? Timestamp()
                let garagename = data["garagename"] as? String ?? ""
                
             
                let dateTime = timestamp.dateValue()
                
                return History(location: location, dateTime: dateTime, garagename: garagename)
            }
            
            self.orderList = orders
        }
    }

    private func formattedDateTime(_ dateTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: dateTime)
    }
}
