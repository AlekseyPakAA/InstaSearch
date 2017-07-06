
import Foundation
import ObjectMapper

class Meta: Mappable {
    
    var code: Int?
    var errorType: String?
    var errorMessage: String?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        code         <- map["code"]
        errorType    <- map["error_type"]
        errorMessage <- map["error_message"]
        
    }
    
    
}
