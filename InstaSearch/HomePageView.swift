//
//  HomePageView.swift
//  InstaSearch
//
//  Created by admin on 01.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

protocol HomePageView: class {

    func insert(index: Int)
    func remove(index: Int)
    func reload(index: Int)
    func performUpdates(deletions: [Int], insertions: [Int], modifications: [Int])
    func reloadData()
    
    func hideRefreshControl()
    func setFooterVisibility(value: Bool)
    
}
