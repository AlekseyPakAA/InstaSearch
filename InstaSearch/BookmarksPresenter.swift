//
//  BookmarksPresenter.swift
//  InstaSearch
//
//  Created by admin on 05.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import RealmSwift

protocol BookmarksPresenter {

    func viewDidLoad()

}

class BookmarksPresenterImpl: BookmarksPresenter {

    weak var view: BookmarksView?;
  
    var databaseInteractor: DatabaseInteractor
  
    var notificationToken: NotificationToken?
    
    required init(view: BookmarksView, databaseInteractor: DatabaseInteractor) {
        self.view = view
        self.databaseInteractor = databaseInteractor
    }
    
    func viewDidLoad() {
        let result = databaseInteractor.list()
        
        notificationToken = result.addNotificationBlock {c in
            switch c {
            case let .update(items, deletions: _, insertions: insertions, modifications: _):
                
                insertions.forEach{ i in
                    let m = items[i]
                    m.saved = true
                    self.view?.add(item: m)
                }
                
            default:
                break
            }
        }

        let media = Array(result)
        media.forEach {m in m.saved = true}
        
        view?.set(items: media)
    }
    
}
