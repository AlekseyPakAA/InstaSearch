//
//  BookmarksController.swift
//  InstaSearch
//
//  Created by admin on 05.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class BookmarksController: UICollectionViewController {

    var cellSize = CGSize()
    var insets = UIEdgeInsets()
    
    var presenter: BookmarksPresenter!

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMMM yyyy"
        return df
    }()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.zeroSymbol = "–"
        return nf
    }()
    
    override func viewDidLoad() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo"),highlightedImage: nil)
        
        let nib = UINib(nibName: "MediaViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "MediaViewCell")
        
        let size = view.frame.size
        calcCellSize(height: size.height, width: size.width)
        
        presenter.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaViewCell", for: indexPath) as! MediaViewCell
      
        let media = presenter.items[indexPath.row]
        
        cell.setup(media: media)

        return cell
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableViewHeader", for: indexPath) as! BookmarksHeader
        headerView.clearBtn.addTarget(self, action: #selector(clearButtonPressed(sender:)), for: UIControlEvents.touchDown)
        return headerView
    }
    
    func clearButtonPressed(sender: UIButton) {
        presenter.clearButtonPressed()
    }
    
}

extension BookmarksController: BookmarksView {
    
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
    
}


extension BookmarksController: UICollectionViewDelegateFlowLayout {
    
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


