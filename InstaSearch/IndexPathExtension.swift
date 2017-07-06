//
//  IndexPathExtension.swift
//  InstaSearch
//
//  Created by admin on 02.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

extension IndexPath {
    
    static func indexPaths(section:Int, start:Int, end:Int) -> [IndexPath] {
        var array = [IndexPath]()
        for row in start...end {
            array.append(IndexPath(row: row, section: section))
        }
        
        return  array
    }
    
}
