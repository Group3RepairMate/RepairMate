import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MechanicSignUpView: View {
    @Binding var currentShowingView: String
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var garageName: String = ""
    @State private var contactNo: String = ""
    @State private var garageAddress: String = ""
    @State private var selectedBookingType: Int = 0
    @State private var showingAlert = false
    @AppStorage("mechanicId") var mechanicId: String = ""
    @EnvironmentObject var garagehelper: Garagehelper
    
    private let bookingTypes = ["Advance", "Immediate", "Both"]
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.[a-z])(?=.[$@$#!%?&])(?=.[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Garage Registration")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
                
                
                Section{
                    Text("Garage Details")
                        .font(.system(size: 24))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,10)
                    
                    TextField("Garage Name", text: $garageName)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                        .padding(.top,5)
                    
                    TextField("Garage Contact No.", text: $contactNo)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.top,5)
                        .autocorrectionDisabled()
                    
                    TextField("Garage Address", text: $garageAddress)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.top,5)
                        .autocorrectionDisabled()
                    
                    Text("Select your booking service:")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,5)
                        .autocorrectionDisabled()
                    Picker(selection: $selectedBookingType, label: Text("Booking Type")) {
                        ForEach(0..<bookingTypes.count) { index in
                            Text(bookingTypes[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top,1)
                }
                
                Section{
                    Text("User Credentials")
                        .font(.system(size: 24))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,25)
                    
                    TextField("Business Email", text: $email)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.top,5)
                        .autocorrectionDisabled()
                    
                    SecureField("Set Password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.top,5)
                        .autocorrectionDisabled()
                }
                
                Button(action: {
                    getRegistrationOfGarage(name: self.garageName, email: self.email, contact: self.contactNo, location: self.garageAddress, availability: self.bookingTypes[selectedBookingType])
                    self.showingAlert = true
                }) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("darkgray"))
                        .cornerRadius(8)
                        .padding(.top,30)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Success!"),
                        message: Text("\(self.garageName) is registered successfully."),
                        dismissButton: .default(Text("OK")) {
                            mechanicId = self.email
                            UserDefaults.standard.set(email, forKey: "MECH_EMAIL")
                            ContentViewForMech()
                        }
                    )
                }
                
                Button(action: {
                    withAnimation {
                        currentShowingView = "login"
                    }
                }) {
                    Text("Already have an account?")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .padding(.top,5)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear(){
            
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    func getRegistrationOfGarage(name:String,email:String,contact:String,location:String,availability:String){
        
        guard let url = URL(string: "https://dark-pear-scallop-toga.cyclic.app/addGarage") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "phone_no":contact,
            "location":location,
            "availability":availability,
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            else{
                DispatchQueue.main.async {
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            UserDefaults.standard.set(email, forKey: "MEMAIL")
                            UserDefaults.standard.set(password, forKey: "MPASS")
                            print("account created successfully.")
                            garagehelper.fetchGaragelist()
                            mechanicId = email
                            
                        }
                    }
                }
            }
        }.resume()
    }
    
}
