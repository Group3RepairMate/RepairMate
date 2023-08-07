import SwiftUI
import FirebaseAuth
import Firebase

struct EditBooking: View {
    var order: Order
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var contact: String = ""
    @State private var unit: String = ""
    @State private var time: Date = Date()
    @State private var street: String = ""
    @State private var postalcode: String = ""
    @State private var problem: String = ""
    @State private var showAlert: Bool = false
    @State private var show: Bool = false
    @State private var isChanged: Bool = false
    @State private var linkselection: Int? = nil
    @Environment(\.dismiss) var dismiss
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            Text("Booking Details")
                .font(.title)
                .foregroundColor(Color("darkgray"))
                .padding(.top, -50)
                .frame(alignment: .center)
                .fontWeight(.semibold)
            
            Form {
                Section(header: Text("Your Name:")) {
                    TextField("\(order.firstName)", text: $firstName)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
                    
                    TextField("\(order.lastName)", text: $lastName)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
                }
                
                Section(header: Text("Your Email:")) {
                    TextField("\(order.email)", text: $email)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
                }
                
                Section(header: Text("Your Contact No:")) {
                    TextField("\(order.contactNo)", text: $contact)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
                }
                
                Section(header: Text("Garage Name:")) {
                    Text("\(order.garageName)")
                }
                
                Section(header: Text("Address:")){
                    
                    TextField("\(order.apartment)", text: $unit)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
                    
                    TextField("\(order.streetname)", text: $street)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
                    
                    TextField("\(order.postalcode)", text: $postalcode)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
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
                    TextField("\(order.problemDisc)", text: $problem, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .autocorrectionDisabled()
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.medium))
                }
            }
            if(order.status == "accepted"){
                Button(action: {
                    if firstName.isEmpty || lastName.isEmpty || email.isEmpty || contact.isEmpty || unit.isEmpty || street.isEmpty || postalcode.isEmpty || problem.isEmpty {
                        showAlert = true
                    } else {
                        updateBooking()
                    }
                }) {
                    Text("Update")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("darkgray"))
                        .cornerRadius(8)
                        .padding(.top,20)
                        .padding(5)
                }
                .alert(isPresented: $showAlert) {
                    if isChanged {
                        return Alert(title: Text("Successful"), message: Text("Order Updated Successfully"), dismissButton: .default(Text("OK")))
                    } else {
                        return Alert(title: Text("Failed"), message: Text("Please Enter all the Details"), dismissButton: .default(Text("OK")))
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
                        .padding(.top,20)
                        .padding(5)
                }
                .sheet(isPresented: $isSheetPresented, content: {
                    Reason(order: order, role: "c")
                })
            }
        }
        .padding(10)
        .onAppear(){
            time = order.date
//            street = order.streetname
//            postalcode = order.postalcode
//            unit = order.apartment
//            email = order.email
//            contact = order.contactNo
//            problem = order.problemDisc
        }
        
        
    }
    
    private func updateBooking() {
        Firestore.firestore().collection("customers").document(UserDefaults.standard.string(forKey: "EMAIL") ?? "").collection("Orderlist").document(order.bookingId).updateData([
            "firstName":firstName,
            "lastName":lastName,
            "emailAddress": email,
            "contactNumber":contact,
            "apartmentNum":unit,
            "streetName":street,
            "postalcode":postalcode,
            "dateTime":time,
            "problemDesc":problem,
        ]) { error in
            if let error = error {
                showAlert = true
            } else {
                showAlert = true
                isChanged = true
            }
        }
    }
}
