//
//  Mechanics_Home.swift
//  RepairMate
//
//  Created by Patel Chintan on 2023-06-24.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct Mechanics_Home: View {
    @State private var orderList: [Order] = []
    @AppStorage("mechanicId") var mechanicId: String = ""
    
    var body: some View {
        if mechanicId ==  ""{
            Mauthview()
        }
        else{
            VStack {
                if orderList.isEmpty {
                    Text("No orders found")
                        .foregroundColor(.gray)
                        .padding()
                }
                else{
                    Text("Your Orders")
                        .font(.largeTitle)
                        .foregroundColor(Color("darkgray"))
                        .padding()
                    List(){
                        ForEach(orderList, id: \.id) { order in
                            NavigationLink(destination: CustomerDetail(detailsview: order)){
                                VStack(alignment: .leading) {
                                    Text("\(order.firstName) \(order.lastName)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                    Text("Date : \(order.date)")
                                    Text("Street Name : \(order.streetname)")
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .onAppear {
                orderList = []
                fetchOrderList()
            }
            .navigationBarBackButtonHidden()
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
}
