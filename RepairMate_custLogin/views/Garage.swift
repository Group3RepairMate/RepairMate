
import Foundation
import CoreLocation

struct Garagesstruct : Codable{
    var list = [Garage]()
}

struct Garage : Codable,Hashable{
    var id : Int
    var name : String
    var location : String
    var email : String
    var phone_no : String
    var availability:String
    
}
