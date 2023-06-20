import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum PaymentOption: String, CaseIterable {
    case cash = "Cash"
    case card = "Card (Booking Charge $50)"
}

struct CustomerDetailsForm: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAddress: String = ""
    @State private var contactNumber: String = ""
    @State private var location: String = ""
    @State private var dateTime: Date = Date()
    @State private var problemDesc: String = ""
    @State private var garagedetail: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var showAlert = false
    @State private var showsuccess = false
    @State private var linkselection: Int? = nil
    @State private var selectedPaymentOption: PaymentOption = .cash
    @State private var goToProfileSetting: Bool = false
    @State private var goToPayment: Bool = false // State variable for navigation to payment view
    
    private func addCustDetails(firstName: String, lastName: String, emailAddress: String, contactNumber: String, location: String, dateTime: Date, problemDesc: String, garagedetail: String) {
        if firstName.isEmpty || lastName.isEmpty || emailAddress.isEmpty || contactNumber.isEmpty || location.isEmpty || problemDesc.isEmpty {
            showAlert = true
            return
        }
        
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "emailAddress": emailAddress,
            "contactNumber": contactNumber,
            "location": location,
            "dateTime": dateTime,
            "problemDesc": problemDesc,
            "garagename": UserDefaults.standard.string(forKey: "GARAGE") ?? ""
        ]
        
        guard let userDocumentID = UserDefaults.standard.string(forKey: "EMAIL") else {
            print("User document ID not found")
            return
        }
        
        Firestore.firestore().collection("Repairmate").document(userDocumentID).collection("Orderlist").addDocument(data: userData) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("Document added")
                showAlert = true
                showsuccess = true
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Customer Details")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
                .padding(10)
            
            NavigationLink(destination: Homescreen(), tag: 1, selection: self.$linkselection) {}
            
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                        .autocorrectionDisabled()
                    TextField("Last Name", text: $lastName)
                        .autocorrectionDisabled()
                    TextField("Email Address", text: $emailAddress)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                    TextField("Contact Number", text: $contactNumber)
                        .autocorrectionDisabled()
                        .keyboardType(.numberPad)
                }
                .padding(8)
                
                Section(header: Text("Booking Details")) {
                    TextField("Location", text: $location)
                        .autocorrectionDisabled()
                    
                    if UserDefaults.standard.string(forKey: "SERVICE") == "Immediate" {
                        let now = Date()
                        DatePicker(selection: $time, in: now..., displayedComponents: .hourAndMinute) {
                            Text("Time")
                        }
                    } else {
                        DatePicker("Date and Time", selection: $dateTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    }
                    
                    TextField("Problem Description", text: $problemDesc)
                        .multilineTextAlignment(.leading)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .autocorrectionDisabled()
                }
                
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
                addCustDetails(firstName: firstName, lastName: lastName, emailAddress: emailAddress, contactNumber: contactNumber, location: location, dateTime: dateTime, problemDesc: problemDesc, garagedetail: garagedetail)
                
                if selectedPaymentOption == .card {
                    goToPayment = true
                }
            }) {
                Text("Book")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(maxWidth: 120)
            }
            .background(Color("darkgray"))
            .cornerRadius(70)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue, lineWidth: 0)
                    .foregroundColor(.black)
            )
            .onAppear() {
                print("email address \(UserDefaults.standard.string(forKey: "EMAIL") ?? "")")
                print("garage name \(UserDefaults.standard.string(forKey: "GARAGE") ?? "")")
            }
        }
        .alert(isPresented: $showAlert) {
            if showsuccess {
                return Alert(title: Text("Successful"), message: Text("Booking Successful."), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Incomplete Form"), message: Text("Please check all the required details."), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .sheet(isPresented: $goToPayment) {
            if selectedPaymentOption == .card {
                PaymentGateway()
            }
        }
        
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

struct CustomerDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        CustomerDetailsForm()
    }
}
