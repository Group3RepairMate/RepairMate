

import SwiftUI
import FirebaseAuth
import Firebase

struct MechanicHistory: View {
    @State private var orderList: [Order] = []
    @AppStorage("mechanicId") var mechanicId: String = ""
    enum Status:String {
        case accepted
        case done
        case undone
        case all
    }
    @State private var status: Status = .all
    @State private var selectedOrder: Order? = nil
    
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
                    Text("All").tag(MechanicHistory.Status.all)
                    if orderList.contains(where: { $0.status == "accepted" }) {
                        Text("Accepted").tag(MechanicHistory.Status.accepted)
                    }
                    if orderList.contains(where: { $0.status == "done" }) {
                        Text("Done").tag(MechanicHistory.Status.done)
                    }
                    if orderList.contains(where: { $0.status == "deleted" }) {
                        Text("Unsuccessful").tag(MechanicHistory.Status.undone)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if(status==Status.all){
                    List(orderList, id: \.id) { order in
                        NavigationLink(
                            destination: EditOrderForMech(order: order),
                            tag: order,
                            selection: $selectedOrder
                        ) {
                            VStack(alignment: .leading) {
                                Text("\(order.garageName)")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                Text("")
                                Text("Date and Time: \(formattedDateTime(order.date))")
                                    .font(.system(size: 13))
                                Button(action: {
                                    // Set the selected order when the button is tapped
                                    selectedOrder = order
                                }) {
                                    Label("Edit", systemImage: "pencil.circle")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .padding()
                                        .cornerRadius(20)
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                if(status==Status.accepted){
                    List(orderList, id: \.id) { order in
                        if(order.status=="accepted"){
                            NavigationLink(
                                destination: EditOrderForMech(order: order),
                                tag: order,
                                selection: $selectedOrder
                            ) {
                                VStack(alignment: .leading) {
                                    Text("\(order.garageName)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                    Text("")
                                    Text("Date and Time: \(formattedDateTime(order.date))")
                                        .font(.system(size: 13))
                                    Button(action: {
                                        // Set the selected order when the button is tapped
                                        selectedOrder = order
                                    }) {
                                        Label("Edit", systemImage: "pencil.circle")
                                            .foregroundColor(.black)
                                            .font(.headline)
                                            .padding()
                                            .cornerRadius(20)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                if(status==Status.done){
                    List(orderList, id: \.id) { order in
                        if(order.status=="done"){
                            NavigationLink(
                                destination: EditOrderForMech(order: order),
                                tag: order,
                                selection: $selectedOrder
                            ) {
                                VStack(alignment: .leading) {
                                    Text("\(order.garageName)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                    Text("")
                                    Text("Date and Time: \(formattedDateTime(order.date))")
                                        .font(.system(size: 13))
                                    Button(action: {
                                        // Set the selected order when the button is tapped
                                        selectedOrder = order
                                    }) {
                                        Label("Edit", systemImage: "pencil.circle")
                                            .foregroundColor(.black)
                                            .font(.headline)
                                            .padding()
                                            .cornerRadius(20)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                if(status==Status.undone){
                    List(orderList, id: \.id) { order in
                        if(order.status=="deleted"){
                            NavigationLink(
                                destination: EditOrderForMech(order: order),
                                tag: order,
                                selection: $selectedOrder
                            ) {
                                VStack(alignment: .leading) {
                                    Text("\(order.garageName)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                    Text("")
                                    Text("Date and Time: \(formattedDateTime(order.date))")
                                        .font(.system(size: 13))
                                    Button(action: {
                                        // Set the selected order when the button is tapped
                                        selectedOrder = order
                                    }) {
                                        Label("Edit", systemImage: "pencil.circle")
                                            .foregroundColor(.black)
                                            .font(.headline)
                                            .padding()
                                            .cornerRadius(20)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            orderList = []
            fetchOrderList()
        }
    }
    
    private func fetchOrderList() {
        Firestore.firestore().collection("customers").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching customers: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found in customers collection")
                return
            }
            
            for customer in documents {
                let customerData = customer.data()
                Firestore.firestore().collection("customers").document(customerData["email"] as! String).collection("Orderlist").getDocuments { (snap,err) in
                    
                    if let err = err {
                        print("Error fetching orders: \(err.localizedDescription)")
                        return
                    }
                    
                    guard let orders = snap?.documents else {
                        print("No orders found in customers collection")
                        return
                    }
                    
                    if(!orders.isEmpty){
                        let fetchedOrder = orders.compactMap { order -> Order? in
                            let data = order.data()
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
                            
                            
                            return Order(bookingId: id,firstName: fname, lastName: lname, email: email, date: date.dateValue(), contactNo: contactNo, apartment:apartment,streetname:streetname,postalcode: postalcode,city: city, status: status, problemDisc: problem,garageemail: garageemail,garageName: garage,avalability: avalability)
                        }
                        
                        for i in fetchedOrder{
                            if(i.garageemail == mechanicId){
                                self.orderList.append(i)
                            }
                        }
                    }
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

struct MechanicHistory_Previews: PreviewProvider {
    static var previews: some View {
        MechanicHistory()
    }
}
