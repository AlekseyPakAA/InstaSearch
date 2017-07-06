
import Foundation
import ObjectMapper
import RealmSwift

class Image:Object, Mappable {
    
    dynamic var width: Int = 0
    dynamic var height: Int = 0
    dynamic var url: String = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        width   <- map["width"]
        height  <- map["height"]
        url     <- map["url"]
    }
    
}
