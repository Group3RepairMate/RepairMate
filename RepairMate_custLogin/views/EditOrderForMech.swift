//
//  EditOrderForMech.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-07-26.
//

import SwiftUI
import Firebase

struct EditOrderForMech: View {
    var order : Order
    @State private var time: Date = Date()
    @State private var showAlert:Bool = false
    @State private var isChanged:Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var isSheetPresented = false
    var body: some View {
        VStack {
            Text("Booking Details")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
                .padding(10)
            
            Form {
                Section(header: Text("Customer Name:")) {
                    Text("\(order.firstName)")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Text("\(order.lastName)")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Customer Email:")) {
                    Text("\(order.email)")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Customer Contact No:")) {
                    Text("\(order.contactNo)")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Customer Address:")){
                    Text("\(order.apartment) \(order.streetname)")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
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
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
            }
            
            Button(action: {
                
                Firestore.firestore().collection("customers").document(UserDefaults.standard.string(forKey: "EMAIL") ?? "").collection("Orderlist").document(order.bookingId).updateData([
                    "dateTime":time,
                ])
                { error in
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
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(maxWidth: 200)
            }
            .background(Color("darkgray"))
            .cornerRadius(70)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
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
            })
            {
                Text("Done")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,20)
            }
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
                Text("Cancel Order")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,30)
            }
            .sheet(isPresented: $isSheetPresented, content: {
                Reason(order: order, role: "m")
            })
        }
        .padding(10)
        .onAppear(){
            time = order.date
        }
    }
}
