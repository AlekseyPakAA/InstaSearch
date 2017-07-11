//
//  HomePagePresenter.swift
//  InstaSearch
//
//  Created by admin on 01.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomePagePresenter {
    
    var items: [Media]{get}
    func viewDidLoad()
    func willDisplayFooter()
    func refreshControlPulled()
    func bookmarksButtonPressed(media: Media)
    func IsItInBookmarks(media: Media) -> Bool
}

class HomePagePresenterImpl: HomePagePresenter {
    
    var items = [Media]()
    
    weak var view: HomePageView?;
    
    var instagramAPI: InstagramAPIInteractor
    var state: PaginationState = .start

    
    var databaseInteractor: DatabaseInteractor
    var token: NotificationToken?
    var previousCollectionIds:[String]!
    
    required init(view: HomePageView, instagramAPI: InstagramAPIInteractor, databaseInteractor: DatabaseInteractor) {
        self.instagramAPI = instagramAPI
        self.databaseInteractor = databaseInteractor
        
        self.view = view
    }

    func viewDidLoad() {
        
        token = databaseInteractor.list().addNotificationBlock { change in
            switch change {
            case let .initial(collection):
               
                self.previousCollectionIds = collection.map {$0.id}
            
            case let .update(collection, deletions: d, insertions: i, modifications: _):
               
                var deletedFromBookmarks = [Int]()
                d.forEach {i in
                    let id = self.previousCollectionIds[i]
                    let index = self.items.index { id == $0.id }
                    if let index = index {
                        deletedFromBookmarks.append(index)
                    }
                }
                
                var insertedToBookmarks = [Int]()
                i.forEach {i in
                    let id = collection[i].id
                    let index = self.items.index { id == $0.id }
                    if let index = index {
                        insertedToBookmarks.append(index)
                    }
                }
            
                var modifications = [Int]()
                modifications.append(contentsOf: deletedFromBookmarks)
                modifications.append(contentsOf: insertedToBookmarks)
                
                self.view?.performUpdates(deletions: [], insertions: [], modifications: modifications)
                
                self.previousCollectionIds = collection.map {$0.id}
                
            case .error:
                break
            
            }
        }
        
    }
    
    func willDisplayFooter() {

        let handler: (InstagramResponce<Media>) -> () = {responce in
            if responce.meta?.code == 200 {
                if let maxID = responce.pagination?.nextMaxID {
                    self.state = .rest(maxID: maxID)
                    self.view?.setFooterVisibility(value: true)
                } else {
                    self.state = .end
                    self.view?.setFooterVisibility(value: false)
                }
                let newItems = responce.data!
                
                let begin = self.items.count
                self.items.append(contentsOf: newItems)
                let end = self.items.count - 1
                let insertions = (begin...end).map{$0}
                self.view?.performUpdates(deletions: [], insertions: insertions, modifications: [])
            }
        }
        
        switch state {
        case .start:
            state = .refreshing
            instagramAPI.users.recentMedia(handler: handler)
        case .rest(let maxID):
            state = .loading
            instagramAPI.users.recentMedia(maxID: maxID, handler: handler)
        default:
            break
        }
        
    }
    
    func refreshControlPulled() {
    
        let handler: (InstagramResponce<Media>) -> () = {responce in
            if responce.meta?.code == 200 {
                if let maxID = responce.pagination?.nextMaxID {
                    self.state = .rest(maxID: maxID)
                    self.view?.setFooterVisibility(value: true)
                } else {
                    self.state = .end
                    self.view?.setFooterVisibility(value: false)
                }
                self.view?.hideRefreshControl()
                
                let newItems = responce.data!
                self.items = newItems
                self.view?.reloadData()
            }
        }
        
        switch state {
        case .start, .rest, .loading, .end:
            state = .refreshing
            instagramAPI.users.recentMedia(handler: handler)
        case .refreshing:
            self.view?.hideRefreshControl()
        }
    
    }
    
    enum PaginationState {
        
        case start
        case refreshing
        case rest(maxID:String)
        case loading
        case end
        
    }
    
    func bookmarksButtonPressed(media: Media) {
        if IsItInBookmarks(media: media) {
            try? databaseInteractor.delete(id: media.id)
        } else {
            try? databaseInteractor.save(copyof: media)
        }
    }
    
    func IsItInBookmarks(media: Media) -> Bool {
        return databaseInteractor.exists(mediaWith: media.id)
    }

    
    deinit {
        token?.stop()
    }

}



