import Foundation
struct Notify: Identifiable,Equatable,Hashable {
    let id = UUID()
    let name: String
    let from: String
    let to: String
    let msg: String
    
    init(name:String,from:String,to:String,msg:String){
        self.name=name
        self.from=from
        self.to=to
        self.msg=msg
    }
}
