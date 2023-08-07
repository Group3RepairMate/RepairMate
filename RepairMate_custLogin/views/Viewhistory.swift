import SwiftUI
import FirebaseFirestore

struct Viewhistory: View {
    @State private var orderList: [Order] = []
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
                    Text("All").tag(Viewhistory.Status.all)
                    if orderList.contains(where: { $0.status == "accepted" }) {
                        Text("Accepted").tag(Viewhistory.Status.accepted)
                    }
                    if orderList.contains(where: { $0.status == "done" }) {
                        Text("Done").tag(Viewhistory.Status.done)
                    }
                    if orderList.contains(where: { $0.status == "deleted" }) {
                        Text("Unsuccessful").tag(Viewhistory.Status.undone)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if(status==Status.all){
                    List(orderList, id: \.id) { order in
                        NavigationLink(
                            destination: EditBooking(order: order),
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
                                destination: EditBooking(order: order),
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
                                destination: EditBooking(order: order),
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
                                destination: EditBooking(order: order),
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

                self.orderList = orders
            }
        }
        
        private func formattedDateTime(_ dateTime: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter.string(from: dateTime)
        }
    }
