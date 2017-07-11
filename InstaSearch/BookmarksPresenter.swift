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

    var items: Results<Media>{get}
    func viewDidLoad()
    func clearButtonPressed()
}

class BookmarksPresenterImpl: BookmarksPresenter {

    weak var view: BookmarksView?;
  
    var databaseInteractor: DatabaseInteractor
  
    var items: Results<Media>
    var token: NotificationToken?
    
    required init(view: BookmarksView, databaseInteractor: DatabaseInteractor) {
        self.view = view
        self.databaseInteractor = databaseInteractor
        
        self.items = databaseInteractor.list()
    }
    
    func viewDidLoad() {
        
        token = items.addNotificationBlock {c in

            switch c {
                
            case let .update(_, deletions: deletions, insertions: insertions, modifications: modifications):
                
                self.view?.performUpdates(deletions: deletions, insertions: insertions, modifications: modifications)
                
            case .initial:
                
                self.view?.reloadData()
                
            default:
                break
            }
        }
    }
    
    func clearButtonPressed() {
        try? databaseInteractor.deleteAll()
    }
    
}
