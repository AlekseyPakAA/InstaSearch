
import Foundation
import ObjectMapper

class InstagramResponce<T: Mappable>: Mappable {
    
    var meta: Meta?
    var pagination:Pagination?
    var data: [T]?
 
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        meta       <- map["meta"]
        pagination <- map["pagination"]
        data       <- map["data"]
    }
    
}




