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
    
    var body: some View {
        List(orderList, id: \.id) { order in
            
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
                    
                    for order in orders{
                        
                    }
                }
            }
        }
    }
}
