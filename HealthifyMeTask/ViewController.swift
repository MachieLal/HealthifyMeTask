//
//  ViewController.swift
//  HealthifyMeTask
//
//  Created by Swarup-Pattnaik on 5/9/17.
//  Copyright © 2017 Swarup-Pattnaik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate let reuseIdentifierTop = "TopContainerCells"
    fileprivate let reuseIdentifierMiddle = "MiddleContainerCells"

    fileprivate let columnsCount: CGFloat = 4
    fileprivate let topCollectionViewSectionInsets = UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 1)
    fileprivate let middleCollectionViewSectionInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)

    fileprivate let filesCount = 10
    fileprivate let indexConstant = 3
    fileprivate var toggle = false
    fileprivate let moreDropDownImage = UIImage.init(named: "moreDropDown")
    fileprivate let lessDropDownImage = UIImage.init(named: "lessDropDown")
    
    fileprivate var imagesArray = Array<UIImage>()
    
    @IBOutlet weak var topCollectionVC: UICollectionView?
    @IBOutlet weak var middleCollectionVC: UICollectionView?

    @IBOutlet weak var topCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0 ..< filesCount {
            imagesArray.append(UIImage.init(named: "\(index + 1)")!)
        }
        topCollectionVC?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.topCollectionVC?.collectionViewLayout.invalidateLayout()
            self.middleCollectionVC?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func imageForIndexPath(_ indexPath: IndexPath) -> UIImage {
        return imagesArray[indexPath.row]
    }
    
    func reverseImagesArray(_ imageArray:[UIImage], startIndex:Int, endIndex:Int){
        if startIndex >= endIndex{
            return
        }
        swap(&imagesArray[startIndex], &imagesArray[endIndex])
        reverseImagesArray(imagesArray, startIndex: startIndex + 1, endIndex: endIndex - 1)
    }
    
    func calculatedTopCollectionWidthPerItem() -> CGFloat {
        let columnsCount = self.columnsCount
        let paddingSpace = self.topCollectionViewSectionInsets.left * (columnsCount + 1)
        let availableWidth = self.view.bounds.width - paddingSpace
        let requiredWidth = availableWidth / columnsCount
        return requiredWidth
    }
    
    func calculatedTopViewHeightHigh() -> CGFloat {
        let columnsCount = Int(self.columnsCount)
        let offset = (filesCount % columnsCount) == 0 ? 0 : 1
        var rowsCount = filesCount / columnsCount + offset
        if (rowsCount == 0) { rowsCount = 1 }
        return self.topCollectionViewSectionInsets.top + (calculatedTopCollectionWidthPerItem() + self.topCollectionViewSectionInsets.left) * CGFloat(rowsCount) + topCollectionViewSectionInsets.bottom
    }

    func calculatedTopViewHeightLow() -> CGFloat {
        return calculatedTopCollectionWidthPerItem() + self.topCollectionViewSectionInsets.top + self.topCollectionViewSectionInsets.left
    }
}

extension ViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionVC {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierTop, for: indexPath) as? TopCollectionViewCell
            if indexPath.row == indexConstant {
                cell?.topImageView?.image = toggle ? lessDropDownImage : moreDropDownImage
            } else  {
                cell?.topImageView?.image = imageForIndexPath(indexPath)
            }
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierMiddle, for: indexPath) as? MiddleCollectionViewCell
                cell?.middleImageView?.image = imageForIndexPath(indexPath)
            return cell!
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == topCollectionVC) {
            let heightConstant = scrollContentViewHeight.constant - topCollectionViewHeight.constant
            topCollectionViewHeight.constant = toggle ? calculatedTopViewHeightHigh() : calculatedTopViewHeightLow()
            scrollContentViewHeight.constant = heightConstant + topCollectionViewHeight.constant
            return CGSize(width: calculatedTopCollectionWidthPerItem(), height: calculatedTopCollectionWidthPerItem())
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - middleCollectionViewSectionInsets.top - middleCollectionViewSectionInsets.bottom)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (collectionView == topCollectionVC) {
            return topCollectionViewSectionInsets
        } else {
            return middleCollectionViewSectionInsets
        }
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == topCollectionVC) {
            if indexPath.row == indexConstant {
                let heightConstant = scrollContentViewHeight.constant - topCollectionViewHeight.constant
                topCollectionViewHeight.constant = toggle ? calculatedTopViewHeightHigh() : calculatedTopViewHeightLow()
                scrollContentViewHeight.constant = heightConstant + topCollectionViewHeight.constant
                toggle = !toggle
                collectionView.reloadData()
            }
        }
        return
    }
}

extension ViewController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (middleCollectionVC != scrollView) {
            return
        }
        let fullyScrolledContentOffset:CGFloat = middleCollectionVC!.frame.size.width * CGFloat(imagesArray.count - 1)
        if (scrollView.contentOffset.x >= fullyScrolledContentOffset) {
            if imagesArray.count>2{
                reverseImagesArray(imagesArray, startIndex: 0, endIndex: imagesArray.count - 1)
                reverseImagesArray(imagesArray, startIndex: 0, endIndex: 1)
                reverseImagesArray(imagesArray, startIndex: 2, endIndex: imagesArray.count - 1)
                let indexPath : IndexPath = IndexPath(row: 1, section: 0)
                middleCollectionVC!.scrollToItem(at: indexPath, at: .left, animated: false)
            }
        }
        else if (scrollView.contentOffset.x == 0){
            if imagesArray.count>2{
                reverseImagesArray(imagesArray, startIndex: 0, endIndex: imagesArray.count - 1)
                reverseImagesArray(imagesArray, startIndex: 0, endIndex: imagesArray.count - 3)
                reverseImagesArray(imagesArray, startIndex: imagesArray.count - 2, endIndex: imagesArray.count - 1)
                let indexPath : IndexPath = IndexPath(row: imagesArray.count - 2, section: 0)
                middleCollectionVC!.scrollToItem(at: indexPath, at: .left, animated: false)
            }
        }
    }
}


