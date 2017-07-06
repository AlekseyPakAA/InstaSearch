//
//  BookmarksView.swift
//  InstaSearch
//
//  Created by admin on 05.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
protocol BookmarksView: class {
    
    //func add(items: [Media])
    func add(item: Media)
    func set(items: [Media])
    func update(item: Media)
    
}
