//
//  RequestAdapter.swift
//  InstaSearch
//
//  Created by admin on 01.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Alamofire

class AccessTokenRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return try URLEncoding.default.encode(urlRequest, with: ["access_token": "2862950100.79ce2d3.3a5375a4caa14ba5ba89d94a0107003f"])
    }
}
