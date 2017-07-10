//
//  BookmarksView.swift
//  InstaSearch
//
//  Created by admin on 05.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

protocol BookmarksView: class {
    
    func insert(index: Int)
    func remove(index: Int)
    func reload(index: Int)
    func performUpdates(deletions: [Int], insertions: [Int], modifications: [Int])
    func reloadData()
    
}
