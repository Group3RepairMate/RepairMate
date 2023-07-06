

import Foundation
struct Order: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    let date: Date
    let contactNo: String
    let apartment: String
    let streetname: String
    let postalcode: String
    let city: String
    let status: String
    let problemDisc: String
    let garageemail:String
    
    init(firstName: String, lastName: String, email: String, date: Date, contactNo: String, apartment: String,streetname:String,postalcode:String,city:String , status: String, problemDisc: String,garageemail:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.date = date
        self.contactNo = contactNo
        self.apartment = apartment
        self.streetname = streetname
        self.postalcode = postalcode
        self.city = city
        self.status = status
        self.problemDisc = problemDisc
        self.garageemail = garageemail
    }
}
