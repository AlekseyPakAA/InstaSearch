import Foundation
import ObjectMapper
import RealmSwift

class Images:Object, Mappable {
    
    dynamic var thumbnail: Image?
    dynamic var lowResolution: Image?
    dynamic var standardResolution: Image?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        thumbnail          <- map["thumbnail"]
        lowResolution      <- map["low_resolution"]
        standardResolution <- map["standard_resolution"]
    }
    
}
