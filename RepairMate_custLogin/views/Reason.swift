import SwiftUI
import Firebase

struct Reason: View {
    var order:Order
    var role:String
    let reasonsForCustomers = ["Out of Town", "Found a better deal from other","Fixed the problem", "Others"]
    let reasonsForMech = ["Out of Town","Out of required tools and equipment","Other"]
    @State private var reason:String = ""
    @State private var selectedIndex = 0
    @State private var showAlert:Bool = false
    @State private var isChanged:Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            Text("Edit Profile")
                .font(.title)
                .padding(15)
            
            if(role=="m"){
                Picker("Select a reason", selection: $selectedIndex) {
                    ForEach(0..<reasonsForMech.count, id: \.self) {
                        Text(reasonsForMech[$0])
                    }
                }
                .pickerStyle(InlinePickerStyle())
                
                if(selectedIndex==2){
                    TextField("write your reason", text: $reason,axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .autocorrectionDisabled()
                }
            }
            else{
                Picker("Select a reason", selection: $selectedIndex) {
                    ForEach(0..<reasonsForCustomers.count, id: \.self) {
                        Text(reasonsForCustomers[$0])
                    }
                }
                .pickerStyle(InlinePickerStyle())
                
                if(selectedIndex==3){
                    TextField("write your reason", text: $reason,axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .autocorrectionDisabled()
                }
            }
            
            Button(action:{
                deleteOrder(role: role)
            })
            {
                Text("Cancel Order")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(10)
            }
            .alert(isPresented: $showAlert) {
                if isChanged {
                    return Alert(title: Text("Successful"), message: Text("Order Delete Successfully"), dismissButton: .default(Text("OK")){
                        dismiss()
                    })
                } else {
                    return Alert(title: Text("Failed"), message: Text("Cannot make the changes"), dismissButton: .default(Text("OK")){
                        dismiss()
                    })
                }
            }
        }
    }
    
    func deleteOrder(role:String){
        print("selected reason \(selectedIndex)")
        Firestore.firestore().collection("customers").document(order.email).collection("Orderlist").document(order.bookingId).updateData([
            "status":"deleted"
        ])
        { error in
            if let error = error {
                print(error)
            } else {
                print("done")
            }
        }
        
        if(role=="m"){
            if(selectedIndex==2){
                let detail: [String: Any] = [
                    "from": order.garageemail,
                    "name":order.garageName,
                    "to": order.email,
                    "msg": "Your order is declined. \(order.garageName) won't attend you on \(order.date) due to following reason.\n Reason: \(reason)",
                    "date": order.date
                ]
                
                addNotification(data: detail)
            }
            else{
                let detail: [String: Any] = [
                    "from": order.garageemail,
                    "name":order.garageName,
                    "to": order.email,
                    "msg": "Your order is declined. \(order.garageName) won't attend you on \(order.date) due to following reason.\n Reason: \(reasonsForMech[selectedIndex])",
                    "date": order.date
                ]
                
                addNotification(data: detail)
            }
        }
        else{
            if(selectedIndex==3){
                let detail: [String: Any] = [
                    "from": order.email,
                    "name":order.firstName+" "+order.lastName,
                    "to": order.garageemail,
                    "msg": "\(order.firstName) \(order.lastName) has declined the order due to following reason.\n Reason: \(reason)",
                    "date": order.date
                ]
                
                addNotification(data: detail)
            }
            else{
                let detail: [String: Any] = [
                    "from": order.email,
                    "name":order.firstName+" "+order.lastName,
                    "to": order.garageemail,
                    "msg": "\(order.firstName) \(order.lastName) has declined the order due to following reason.\n Reason: \(reasonsForCustomers[selectedIndex])",
                    "date": order.date
                ]
                
                addNotification(data: detail)
            }
        }
    }
    
    func addNotification(data:[String:Any]){
        Firestore.firestore().collection("notifications").addDocument(data: data)
        { error in
            if let error = error {
                showAlert=true
            } else {
                showAlert=true
                isChanged=true
            }
        }
    }
}
