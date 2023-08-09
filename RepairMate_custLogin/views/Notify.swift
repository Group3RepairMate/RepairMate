import Foundation
struct Notify: Identifiable,Equatable,Hashable {
    let id = UUID()
    let name: String
    let from: String
    let to: String
    let msg: String
    let date:Date
    
    init(name:String,from:String,to:String,msg:String, date:Date){
        self.name=name
        self.from=from
        self.to=to
        self.msg=msg
        self.date = Date.now
    }
}
