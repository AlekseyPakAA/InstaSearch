//
//  File.swift
//  InstaSearch
//
//  Created by admin on 04.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Comments:Object, Mappable {
    
    dynamic var count: Int = 0
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        count <- map["count"]
    }
    
}
