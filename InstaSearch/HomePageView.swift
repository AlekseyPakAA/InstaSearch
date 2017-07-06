//
//  HomePageView.swift
//  InstaSearch
//
//  Created by admin on 01.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

protocol HomePageView: class {

    func add(items: [Media])
    func set(items: [Media])
    func update(item: Media)
    
    func hideRefreshControl()
    func setFooterVisibility(value: Bool)
    
}
