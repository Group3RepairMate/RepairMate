import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum PaymentOption: String, CaseIterable {
    case cash = "Cash"
    case card = "Card (Booking Charge $50)"
}

struct CustomerDetailsForm: View {
    var detailsview: Garage
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var contactNumber: String = ""
    @State private var streetname: String = ""
    @State private var apartment: String = ""
    @State private var city: String = ""
    @State private var postal: String = ""
    @State private var dateTime: Date = Date()
    @State private var problemDesc: String = ""
    @State private var time: Date = Date()
    @State private var showAlert = false
    @State private var showsuccess = false
    @State private var linkselection: Int? = nil
    @State private var paymentselection: Int? = nil
    @State private var selectedPaymentOption: PaymentOption = .cash
    @State private var goToProfileSetting: Bool = false
    @State private var goToPayment: Bool = false
    @State private var showcard: Bool = false
    
    private func addCustDetails(firstName: String, lastName: String, emailAddress: String, contactNumber: String, apartment: String,streetname: String,postal:String,city: String, dateTime: Date, problemDesc: String) {
        if firstName.isEmpty || lastName.isEmpty || emailAddress.isEmpty || contactNumber.isEmpty || streetname.isEmpty || apartment.isEmpty || postal.isEmpty || city.isEmpty || problemDesc.isEmpty {
            showAlert = true
            showsuccess = false
            return
        }
        
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "emailAddress": emailAddress,
            "contactNumber": contactNumber,
            "apartmentNum":apartment,
            "streetName": streetname,
            "postalcode":postal,
            "city":city,
            "dateTime": dateTime,
            "problemDesc": problemDesc,
            "garagename": detailsview.name,
            "garageemail":detailsview.email,
            "status": "processing",
            "garageAvailability":detailsview.availability
        ]
        
        guard let userID = UserDefaults.standard.string(forKey: "EMAIL") else {
            print("User document ID not found")
            return
        }
        
        let collectionRef = Firestore.firestore().collection("customers").document(userID).collection("Orderlist")
        
        let documentRef = collectionRef.addDocument(data: userData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                showAlert = true
                showsuccess = true
            }
        }
        
        let documentID = documentRef.documentID
        collectionRef.document(documentID).updateData(["bookingID":documentID]){ error in
            if let error = error {
                print("Error adding field: \(error)")
            } else {
                showAlert = true
                
            }
        }
        
    }
    
    var body: some View {
        
        VStack {
            Text("Customer Details")
                .foregroundColor(Color("darkgray"))
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top,-33)
            
            NavigationLink(destination: Homescreen(), tag: 1, selection: self.$linkselection) {}
            
            NavigationLink(destination: PaymentGateway(), tag: 1, selection: self.$paymentselection) {}
            
            Form {
                
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.regular))
                    TextField("Last Name", text: $lastName)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.regular))
                    TextField("Contact Number", text: $contactNumber)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.regular))
                        .keyboardType(.numberPad)
                }
                .padding(5)
                
                Section(header: Text("Booking Details")) {
                    TextField("Apartment", text: $apartment)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.regular))
                    TextField("Street Name", text: $streetname)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.regular))
                    TextField("Postal Code", text: $postal)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.regular))
                    TextField("City", text: $city)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.leading)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .font(.title2.weight(.regular))
                    if detailsview.availability == "Immediate" {
                        let now = Date()
                        DatePicker(selection: $time, in: now..., displayedComponents: .hourAndMinute) {
                            Text("Time")
                        }
                    } else {
                        DatePicker("Date and Time", selection: $dateTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    }
                    
                    TextField("Problem Description", text: $problemDesc,axis: .vertical)
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
                .padding(5)
                Section(header: Text("Payment Option")) {
                    ForEach(PaymentOption.allCases, id: \.self) { option in
                        Toggle(option.rawValue, isOn: Binding<Bool>(
                            get: { self.selectedPaymentOption == option },
                            set: { _ in self.selectedPaymentOption = option }
                        ))
                        .toggleStyle(RadioButtonStyle())
                    }
                }
            }
            
            Button(action: {
                if detailsview.availability == "Immediate" {
                    let now = Date()
                    addCustDetails(firstName: firstName, lastName: lastName,  emailAddress: UserDefaults.standard.string(forKey: "EMAIL") ?? "", contactNumber: contactNumber, apartment: apartment, streetname: streetname, postal: postal, city: city , dateTime: time, problemDesc: problemDesc)
                } else {
                    addCustDetails(firstName: firstName, lastName: lastName, emailAddress: UserDefaults.standard.string(forKey: "EMAIL") ?? "", contactNumber: contactNumber, apartment: apartment, streetname: streetname, postal: postal, city: city , dateTime: dateTime, problemDesc: problemDesc)
                }
                
                if selectedPaymentOption == .card {
                    self.paymentselection = 1
                }
                else if  selectedPaymentOption == .cash {
                    firstName = ""
                    lastName = ""
                    contactNumber = ""
                    streetname = ""
                    apartment = ""
                    city = ""
                    postal = ""
                    dateTime = Date()
                    problemDesc = ""
                    linkselection = 1
                }
            }) {
                Text("Book")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkgray"))
                    .cornerRadius(8)
                    .padding(.top,20)
                    .padding(5)
            }
            
        }
        .alert(isPresented: $showAlert) {
            if showsuccess {
                
                return Alert(title: Text("Successful"), message: Text("Booking Successful."), dismissButton: .default(Text("OK")))
                
            }
            else {
                return Alert(title: Text("Incomplete Form"), message: Text("Please check all the required details."), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        
        Spacer()
    }
    
}

struct RadioButtonStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "largecircle.fill.circle" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}
