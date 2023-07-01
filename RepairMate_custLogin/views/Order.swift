

import Foundation
struct Order: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    let date: Date
    let contactNo: String
    let location: String
    let garage: String
    let status: String
    let problemDisc: String
    
    init(firstName: String, lastName: String, email: String, date: Date, contactNo: String, location: String, garage: String, status: String, problemDisc: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.date = date
        self.contactNo = contactNo
        self.location = location
        self.garage = garage
        self.status = status
        self.problemDisc = problemDisc
    }
}
