//
//  HomePageController.swift
//  InstaSearch
//
//  Created by admin on 27.06.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SDWebImage

class HomePageController: UIViewController {
    
    var cellSize = CGSize()
    var insets = UIEdgeInsets()
    
    var presenter: HomePagePresenter!;

    @IBOutlet var collectionView: UICollectionView!
    
    var footerIsVisible = true
    
    override func viewDidLoad() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo"),highlightedImage: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlPulled(sender:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        let nib = UINib(nibName: "MediaViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MediaViewCell")
 
        let size = view.frame.size
        calcCellSize(height: size.height, width: size.width)
        
        presenter.viewDidLoad()
    }
    
    func refreshControlPulled(sender: UIRefreshControl) {
        presenter.refreshControlPulled()
    }
    
    func bookmarksButtonPressed(sender: UIButton) {
        let globalPoint = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: globalPoint) {
            presenter.bookmarksButtonPressed(media: presenter.items[indexPath.row])
        } 
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        calcCellSize(height: size.height, width: size.width)
        
        collectionView?.reloadData()
    }
    
    private func calcCellSize(height: CGFloat, width: CGFloat) {
    
        if height < width {
            insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            cellSize.width = (width - insets.left * 3) / 2
        } else {
            insets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
            cellSize.width = width
        }
        
        cellSize.height = 50 + cellSize.width + 12 + 24 + 12 + 12 + 12
    }
    
    
}

extension HomePageController: HomePageView {
    
    func reloadData() {
        collectionView?.reloadData()
    }
    
    func insert(index: Int) {
        collectionView?.insertItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func reload(index: Int) {
        collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func remove(index: Int) {
        collectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func performUpdates(deletions: [Int], insertions: [Int], modifications: [Int]) {
        collectionView?.performBatchUpdates({
            deletions.forEach { index in
                self.collectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
            
            insertions.forEach{ index in
                self.collectionView?.insertItems(at: [IndexPath(row: index, section: 0)])
            }
            
            
            modifications.forEach { index in
                self.collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
            
        }, completion: nil)
    }
    
    func hideRefreshControl() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    func setFooterVisibility(value: Bool) {
        footerIsVisible = value
    }
    
}
extension HomePageController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaViewCell", for: indexPath) as! MediaViewCell

        let media = presenter.items[indexPath.row]
        
        cell.setup(media: media)
        
        cell.bookmarkBtn.addTarget(self, action: #selector(bookmarksButtonPressed(sender:)), for: UIControlEvents.touchDown)
      
        
        if presenter.IsItInBookmarks(media: media) {
            cell.bookmarkBtn.setImage(#imageLiteral(resourceName: "bookmarks_btn_hl"), for: .normal)
        } else {
            cell.bookmarkBtn.setImage(#imageLiteral(resourceName: "bookmarks_btn"), for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableViewFooter", for: indexPath)
        return footerView
    }

}

extension HomePageController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) { 
        
          view.isHidden = !footerIsVisible
        
            if view.reuseIdentifier == "UICollectionReusableViewFooter" {
                presenter.willDisplayFooter()
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if footerIsVisible {
            return CGSize(width: view.frame.width, height: 50)
        } else {
            return CGSize(width: view.frame.width, height: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insets.left
    }
    
}
