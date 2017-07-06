
import Foundation
import ObjectMapper

class Pagination: Mappable {
    
    var nextURL: URL?
    var nextMaxID: String?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        nextURL   <- map["next_url"]
        nextMaxID <- map["next_max_id"]
    }
}
