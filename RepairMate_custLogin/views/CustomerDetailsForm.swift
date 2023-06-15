import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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
    
    var loginuser : String = ""
    @State private var goToProfileSetting: Bool = false
    
    private func addCustDetails(firstName: String, lastName: String, emailAddress: String, contactNumber: String, location: String, dateTime: Date, problemDesc: String, garagedetail: String) {
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
                print("Document added ")
            }
        }
    }
    
    
    var body: some View {
        VStack {
            Text("Customer Details")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
            
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email Address", text: $emailAddress)
                        .keyboardType(.emailAddress)
                    TextField("Contact Number", text: $contactNumber)
                        .keyboardType(.numberPad)
                }
                .padding(8)
                
                Section(header: Text("Booking Details")) {
                    TextField("Location", text: $location)
                    if(UserDefaults.standard.string(forKey: "SERVICE") == "Immediate"){
                        DatePicker(selection: $time, displayedComponents: .hourAndMinute) {
                            Text("Time")
                        }
                    }
                    else{
                        DatePicker("Date and Time", selection: $dateTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    }
                    
                    TextField("Problem Description", text: $problemDesc)
                        .multilineTextAlignment(.leading)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                }
            }
            
            Button(action: {
                addCustDetails(firstName: firstName, lastName: lastName, emailAddress: emailAddress, contactNumber: contactNumber, location: location, dateTime: dateTime, problemDesc: problemDesc, garagedetail: garagedetail)
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
            .onAppear(){
                print("email address \(UserDefaults.standard.string(forKey: "EMAIL") ?? "")")
                print("garage name \(UserDefaults.standard.string(forKey: "GARAGE") ?? "")")
                
            }
        }
        Spacer()
    }
}

struct CustomerDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        CustomerDetailsForm()
    }
}
