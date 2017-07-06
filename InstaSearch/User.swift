
import Foundation
import ObjectMapper

import RealmSwift

class User:Object, Mappable  {
    
    dynamic var id: String = ""
    dynamic var fullName: String = ""
    dynamic var profilePicture: String = ""
    dynamic var username: String = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id             <- map["id"]
        fullName       <- map["full_name"]
        profilePicture <- (map["profile_picture"])
        username       <- map["username"]
    }
    
}
