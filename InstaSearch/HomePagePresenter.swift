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

}

class HomePagePresenterImpl: HomePagePresenter {
    
    var items = [Media]()
    
    weak var view: HomePageView?;
    
    var instagramAPI: InstagramAPIInteractor

    var databaseInteractor: DatabaseInteractor
    var token: NotificationToken?
    
    var state: PaginationState = .start
    
    required init(view: HomePageView, instagramAPI: InstagramAPIInteractor, databaseInteractor: DatabaseInteractor) {
        self.instagramAPI = instagramAPI
        self.databaseInteractor = databaseInteractor
        
        self.view = view
    }

    func viewDidLoad() {
        token = databaseInteractor.list().addNotificationBlock {change in
            switch change {
            case let .update(collection, deletions: _, insertions: insertions, modifications: modifications):
                
                var m = [Int]()
                modifications.forEach {
                    if let index = self.items.index(of: collection[$0]) {
                        m.append(index)
                    }
                }
                
                self.view?.performUpdates(deletions: [], insertions: [], modifications: m)
                
            default:
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
                self.syncWithDB(media: newItems)
                
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
                self.syncWithDB(media: newItems)
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

    private func syncWithDB(media: [Media]) {
        for i in 0..<media.count{
            if let item = self.databaseInteractor.object(id: media[i].id) {
                databaseInteractor.set(media: media[i], bookmarks: item.bookmarks)
                self.databaseInteractor.save(media: media[i])
            }
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
        if let _ = databaseInteractor.object(id: media.id) {
            databaseInteractor.set(media: media, bookmarks: !media.bookmarks)
        } else {
            media.bookmarks = true
            databaseInteractor.save(media: media)
        }
    }
    
    deinit {
        token?.stop()
    }

}



