//
//  TopCollectionVC.swift
//  HealthifyMeTask
//
//  Created by Swarup on 5/11/17.
//  Copyright © 2017 Swarup-Pattnaik. All rights reserved.
//

import UIKit


class TopCollectionVC: UICollectionViewController {
    fileprivate let reuseIdentifier = "TopContainerCells"
    fileprivate let columnsCount: CGFloat = 4
    fileprivate let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    fileprivate let filesCount = 30
    fileprivate let indexConstant = 3
    fileprivate var toggle = false
    fileprivate let moreDropDownImage = UIImage.init(named: "moreDropDown")
    fileprivate let lessDropDownImage = UIImage.init(named: "lessDropDown")

    lazy var widthPerItem : CGFloat = {
        let columnsCount = self.columnsCount
        let paddingSpace = self.sectionInsets.left * (columnsCount + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        return availableWidth / columnsCount
    }()
    
    lazy var tableViewHeightHigh : CGFloat = {
        let rowsCount = self.filesCount / Int(self.columnsCount)
        return self.sectionInsets.top + (self.widthPerItem + self.sectionInsets.left) * CGFloat(rowsCount) + self.sectionInsets.bottom
    }()
    
    lazy var tableViewHeightLow : CGFloat = {
        return self.widthPerItem + self.sectionInsets.top + self.sectionInsets.left
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.collectionViewLayout.invalidateLayout()
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filesCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TopCollectionViewCell
        if indexPath.row == indexConstant {
            cell?.topImageView?.image = toggle ? moreDropDownImage : lessDropDownImage
        } else  {
            cell?.topImageView?.image = UIImage.init(named: "\(indexPath.row + 1)")
        }
        return cell!
    }
}

extension TopCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size.height = toggle ? tableViewHeightHigh : tableViewHeightLow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension TopCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == indexConstant {
            collectionView.frame.size.height = toggle ? tableViewHeightHigh : tableViewHeightLow
            toggle = !toggle
            collectionView.reloadData()
        }
        return
    }

}

