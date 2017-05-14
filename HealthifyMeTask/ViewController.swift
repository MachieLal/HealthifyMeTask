//
//  ViewController.swift
//  HealthifyMeTask
//
//  Created by Swarup-Pattnaik on 5/9/17.
//  Copyright © 2017 Swarup-Pattnaik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate let reuseIdentifier = "TopContainerCells"
    fileprivate let columnsCount: CGFloat = 4
    fileprivate let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    fileprivate let filesCount = 11
    fileprivate let indexConstant = 3
    fileprivate var toggle = false
    fileprivate let moreDropDownImage = UIImage.init(named: "moreDropDown")
    fileprivate let lessDropDownImage = UIImage.init(named: "lessDropDown")
    
    @IBOutlet weak var topCollectionVC: UICollectionView?
    @IBOutlet weak var topCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!

    lazy var widthPerItem : CGFloat = {
        let columnsCount = self.columnsCount
        let paddingSpace = self.sectionInsets.left * (columnsCount + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        return availableWidth / columnsCount
    }()
    
    lazy var tableViewHeightHigh : CGFloat = {
        let columnsCount = Int(self.columnsCount)
        let offset = (self.filesCount % columnsCount) == 0 ? 0 : 1
        var rowsCount = self.filesCount / columnsCount + offset
        if (rowsCount == 0) { rowsCount = 1 }
        return self.sectionInsets.top + (self.widthPerItem + self.sectionInsets.left) * CGFloat(rowsCount) + self.sectionInsets.bottom
    }()
    
    lazy var tableViewHeightLow : CGFloat = {
        return self.widthPerItem + self.sectionInsets.top + self.sectionInsets.left
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCollectionVC?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.topCollectionVC?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension ViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TopCollectionViewCell
        if indexPath.row == indexConstant {
            cell?.topImageView?.image = toggle ? moreDropDownImage : lessDropDownImage
        } else  {
            cell?.topImageView?.image = UIImage.init(named: "\(indexPath.row + 1)")
        }
        return cell!
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightConstant = scrollContentViewHeight.constant - topCollectionViewHeight.constant
        topCollectionViewHeight.constant = toggle ? tableViewHeightHigh : tableViewHeightLow
        scrollContentViewHeight.constant = heightConstant + topCollectionViewHeight.constant
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == indexConstant {
            let heightConstant = scrollContentViewHeight.constant - topCollectionViewHeight.constant
            topCollectionViewHeight.constant = toggle ? tableViewHeightHigh : tableViewHeightLow
            scrollContentViewHeight.constant = heightConstant + topCollectionViewHeight.constant
            toggle = !toggle
            collectionView.reloadData()
        }
        return
    }
    
}

