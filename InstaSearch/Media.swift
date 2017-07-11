
import Foundation
import ObjectMapper

import RealmSwift

class Media:Object, Mappable {
    
    dynamic var id: String = ""
    dynamic var createdTime: String = ""
    
    dynamic var user: User?
    dynamic var imageURL: String = ""
    
    dynamic var likesCount: Int = 0
    dynamic var commentsCount:Int = 0
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id            <- map["id"]
        createdTime   <- map["created_time"]
        likesCount    <- map["likes.count"]
        commentsCount <- map["comments.count"]
        imageURL      <- map["images.standardResolution.url"]
        user          <- map["user"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}








