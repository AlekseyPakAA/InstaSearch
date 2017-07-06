//
//  HomePagePresenter.swift
//  InstaSearch
//
//  Created by admin on 01.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
protocol HomePagePresenter {
 
    func viewDidLoad()
    func willDisplayFooter()
    func refreshControlPulled()
    func addToBookmarksButtonPressed(media: Media)
    
}

class HomePagePresenterImpl: HomePagePresenter {

    weak var view: HomePageView?;
    var instagramAPI: InstagramAPIInteractor
    var databaseInteractor: DatabaseInteractor

    var state: PaginationState = .start
    
    required init(view: HomePageView, instagramAPI: InstagramAPIInteractor, databaseInteractor: DatabaseInteractor) {
        self.view = view
        self.instagramAPI = instagramAPI
        self.databaseInteractor = databaseInteractor
    }

    func viewDidLoad() {
        
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
                responce.data!.forEach {m in self.setSavedProrerty(media: m)}
                self.view?.add(items: responce.data!)
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
    
    private func setSavedProrerty(media: Media) {
        let item = databaseInteractor.object(id: media.id)
        if let _ = item {
            media.saved = true
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
                responce.data!.forEach {m in self.setSavedProrerty(media: m)}
                self.view?.set(items: responce.data!)
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
    
    func addToBookmarksButtonPressed(media: Media) {
        do {
            try databaseInteractor.save(media: media)
        } catch {
            return
        }
        
        media.saved = true;
        view?.update(item: media)
    }

}



