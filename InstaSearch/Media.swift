
import Foundation
import ObjectMapper

import RealmSwift

class Media:Object, Mappable {
    
    dynamic var id: String = ""
    dynamic var createdTime: String = ""
    
    dynamic var user: User?
    dynamic var images: Images?
    
    dynamic var likes: Likes?
    dynamic var comments: Comments?
    
    dynamic var bookmarks: Bool = false
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        createdTime <- map["created_time"]
        likes       <- map["likes"]
        comments    <- map["comments"]
        images      <- map["images"]
        user        <- map["user"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}








