//
//  EditOrderForMech.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-07-26.
//

import SwiftUI
import Firebase

struct EditOrderForMech: View {
    var order: Order
    @State private var time: Date = Date()
    @State private var showAlert: Bool = false
    @State private var isChanged: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            Text("Booking Details")
                .font(.title)
                .foregroundColor(Color("darkgray"))
                .padding(.top, -48)
                .frame(alignment: .center)
                .fontWeight(.semibold)
            
            Form {
                Section(header: Text("Customer Name:")) {
                    Text("\(order.firstName)")
                        .padding()
                    Text("\(order.lastName)")
                        .padding()
                }
                
                Section(header: Text("Customer Email:")) {
                    Text("\(order.email)")
                        .padding()
                }
                
                Section(header: Text("Customer Contact No:")) {
                    Text("\(order.contactNo)")
                        .padding()
                }
                
                Section(header: Text("Customer Address:")){
                    Text("\(order.apartment) \(order.streetname)")
                        .padding()
                }
                
                if(order.garageAvailability == "Immediate"){
                    Section(header: Text("Time:")) {
                        let now = Date()
                        DatePicker(selection: $time, in: now..., displayedComponents: .hourAndMinute) {
                            Text("Selected Time:")
                        }
                    }
                }
                else{
                    Section(header: Text("Date and Time:")) {
                        DatePicker(selection: $time, in: Date()..., displayedComponents: [.date, .hourAndMinute]){
                            Text("Selected Date and Time:")
                        }
                    }
                }
                
                Section(header: Text("Problrm to fix:")){
                    Text("\(order.problemDisc)")
                        .padding()
                }
            }
            
            VStack() {
                if(order.status == "accepted"){
                    HStack{
                    Button(action: {
                        Firestore.firestore().collection("customers").document(order.email).collection("Orderlist").document(order.bookingId).updateData(
                            ["status":"done"]) { error in
                                if let error = error {
                                    print("Error deleting order: \(error)")
                                    showAlert = true
                                } else {
                                    showAlert = true
                                    isChanged = true
                                }
                            }
                    }) {
                        Text("Done")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(15)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.green)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 60)
                            .stroke(Color.blue,lineWidth: 0)
                            .foregroundColor(.black)
                    )
                    .padding(.leading,30)
                    .padding(.top,10)
                    
                    .alert(isPresented: $showAlert) {
                        if isChanged {
                            return Alert(title: Text("Successful"), message: Text("Order completed Successfully"), dismissButton: .default(Text("OK")))
                        } else {
                            return Alert(title: Text("Failed"), message: Text("Cannot make the order done"), dismissButton: .default(Text("OK")))
                        }
                    }
                    
                    Button(action: {
                        isSheetPresented = true
                    }) {
                        Text("Cancel")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(15)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.red)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 60)
                            .stroke(Color.red,lineWidth: 0)
                            .foregroundColor(.black)
                    )
                    .padding(.trailing,30)
                    .padding(.top,10)
                    .sheet(isPresented: $isSheetPresented, content: {
                        Reason(order: order, role: "m")
                    })
                }
                Button(action: {
                    Firestore.firestore().collection("customers").document(UserDefaults.standard.string(forKey: "EMAIL") ?? "").collection("Orderlist").document(order.bookingId).updateData([
                        "dateTime":time,
                    ]) { error in
                        if let error = error {
                            showAlert = true
                        } else {
                            showAlert = true
                            isChanged = true
                        }
                    }
                    dismiss()
                }) {
                    Text("Update")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(15)
                        .frame(maxWidth: 310)
                }
                .background(Color.blue)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 60)
                        .stroke(Color.blue,lineWidth: 0)
                        .foregroundColor(.black)
                )
                
                .alert(isPresented: $showAlert) {
                    if isChanged {
                        return Alert(title: Text("Successful"), message: Text("Changes made"), dismissButton: .default(Text("OK")))
                    } else {
                        return Alert(title: Text("Failed"), message: Text("Cannot make the changes"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            //            .padding(.top, 30)
            //            .padding(.bottom, 30)
        }
    }
        .padding(10)
        .onAppear(){
            time = order.date
        }
    }
}
