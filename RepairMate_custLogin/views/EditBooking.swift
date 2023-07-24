import SwiftUI
import FirebaseAuth
import Firebase


struct EditBooking: View {
    var order : Order
    @State private var email: String = ""
    @State private var contact: String = ""
    @State private var unit: String = ""
    @State private var time: Date = Date()
    @State private var street: String = ""
    @State private var postalcode: String = ""
    @State private var problem: String = ""
    @State private var showAlert:Bool = false
    @State private var isChanged:Bool = false
    @State private var linkselection : Int? = nil
    
    var body: some View {
        VStack {
            Text("Booking Details")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
                .padding(10)
            
            Form {
                Section(header: Text("Your Email:")) {
                    TextField("\(order.email)", text: $email)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Your Contact No:")) {
                    TextField("\(order.contactNo)", text: $contact)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Garage Name:")) {
                    Text("\(order.garageName)")
                }
                
                Section(header: Text("Address:")){
                    Text("Unit No:")
                        .bold()
                    TextField("\(order.apartment)", text: $unit)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Text("Street:")
                        .bold()
                    TextField("\(order.streetname)", text: $street)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Text("Postal code:")
                        .bold()
                    TextField("\(order.postalcode)", text: $postalcode)
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
                
                Section(header: Text("Problem to fix:")) {
                    TextField("Problem Description", text: $problem,axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .autocorrectionDisabled()
                }
            }
//            NavigationLink(destination: Homescreen(), tag: 1, selection:self.$linkselection){}

            Button(action: {
                
                Firestore.firestore().collection("customers").document(UserDefaults.standard.string(forKey: "EMAIL") ?? "").collection("Orderlist").document(order.bookingId).updateData([
                    "emailAddress": email,
                    "contactNumber":contact,
                    "apartmentNum":unit,
                    "streetName":street,
                    "postalcode":postalcode,
                    "dateTime":time,
                    "problemDesc":problem
                ])
                { error in
                    if let error = error {
                        showAlert = true
                    } else {
                        showAlert = true
                        isChanged = true
                    }
                }
                
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
                deleteOrder()
                self.linkselection = 1
            }) {
                Text("Delete Order")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(maxWidth: 200)
            }
            .background(Color.red)
            .cornerRadius(70)
            .alert(isPresented: $showAlert) {
                if isChanged {
                  
                    return Alert(title: Text("Successful"), message: Text("Order Delete Successfully"), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Failed"), message: Text("Cannot make the changes"), dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding(10)
        .onAppear(){
            time = order.date
            street = order.streetname
            postalcode = order.postalcode
            unit = order.apartment
            email = order.email
            contact = order.contactNo
            problem = order.problemDisc
        }
    }
    private func deleteOrder() {
        guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
            print("User document ID not found")
            return
        }
        
        Firestore.firestore().collection("customers").document(userDocumentID).collection("Orderlist").document(order.bookingId).delete { error in
            if let error = error {
                print("Error deleting order: \(error)")
                showAlert = true
            } else {
               
                showAlert = true
                isChanged = true
              
            }
        }
    }
}

