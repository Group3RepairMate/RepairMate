//
//  CustomerDetailsForm.swift
//  RepairMate
//
//  Created by Arjun Roperia on 2023-06-12.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CustomerDetailsForm: View {
    
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var emailAddress : String = ""
    @State private var contactNumber : String = ""
    @State private var location : String = ""
    @State private var date : Date = Date.now
    @State private var problemDesc : String = ""
    
    @State private var goToProfileSetting : Bool = false
    
    
//    private func createNewUser(email : String, password : String) {
//        var userData : [String:Any] = [
//            "email" : email,
//            "password" : password,
//        ]
//        Firestore.firestore().collection("RepairMate").document(email).setData(userData,merge: false)
//    }
    private func addCustDetails(firstName : String, lastName : String, emailAddress : String, contactNumber : String, location : String, date : Date, problemDesc : String){
        var userData : [String : Any] = [
            "firstName" : firstName,
            "lastName" : lastName,
            "emailAddress" : emailAddress,
            "contactNumber" : contactNumber,
            "location" : location,
            "dateTime" : date,
            "problemDesc" : problemDesc
        ]
        
        Firestore.firestore().collection("Repairmate").document(emailAddress).setData(userData,merge : true)
    }
    var body: some View {
        
       
        VStack{
            
            Text("Customer Details")
                .font(.largeTitle)
                .padding()
            Form{
                Section{
                    TextField("First Name",text: $firstName)
                }
                Section{
                    TextField("Last Name",text: $lastName)
                }
                Section{
                    TextField("Email Address",text : $emailAddress)
                }
                Section{
                    TextField("Contact Number",text: $contactNumber)
                }
                Section{
                    TextField("Location",text: $location)
                }
                Section{
                    DatePicker(selection: $date){
                        Text("Select date")
                    }
                    
                }
                Section{
                    TextField("Problem Desctiption",text: $problemDesc)
                        
                }
                NavigationLink(destination : ProfileSettingView(), isActive: $goToProfileSetting){
                    Button(
                        action : {
                       
                        self.goToProfileSetting = true
                    }){
                        Text("Book Now")
                    }
            }
                
                Button{
                    addCustDetails(firstName: firstName, lastName: lastName, emailAddress: emailAddress, contactNumber: contactNumber, location: location, date: date, problemDesc: problemDesc)
                } label: {
                    Text("Save Details")
                }
            }
            
        }
        
        
    }
}

struct CustomerDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        CustomerDetailsForm()
    }
}
