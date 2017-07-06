
import Foundation
import Alamofire
import ObjectMapper

class InstagramAPIInteractor {
    
    static let BASE_URL = "https://api.instagram.com/v1"
    let users = UsersAPI()
    
}

class UsersAPI {
    
    fileprivate init() {
        
    }
    
    func recentMedia(userID: String = "self", maxID: String? = nil, handler: @escaping (InstagramResponce<Media>) -> Void) {
        let stringURL = "\(InstagramAPIInteractor.BASE_URL)/users/\(userID)/media/recent/"

        var params = [URLQueryItem]()
        params.append(URLQueryItem(name: "count", value: "10"))
        if let temp = maxID {
            params.append(URLQueryItem(name: "max_id",value: temp))
        }
        
        var builder = URLComponents(string: stringURL)!
        builder.queryItems = params
        let url = try! builder.asURL()

        Alamofire.request(url).responseString { responce in
            if let json = responce.result.value {
                let result =  InstagramResponce<Media>(JSONString: json)!
                handler(result)
            }
        }
    }
    
}
