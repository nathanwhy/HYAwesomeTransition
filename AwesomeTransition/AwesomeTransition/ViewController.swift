//
//  ViewController.swift
//  AwesomeTransition
//
//  Created by why on 16/4/18.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageStrings: [String] = []
    weak var transitionCell: UIView?
    lazy var transition: AwesomeTransition = {
        let transition = AwesomeTransition()
        transition.containerBackgroundView = NSBundle.mainBundle().loadNibNamed("ContainerView", owner: nil, options: nil).last as? UIView
        return transition
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for _ in 0...30 {
            imageStrings.append("doge")
        }
        imageStrings[10] = "doge2"
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStrings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
        cell.imageView.image = UIImage(named: imageStrings[indexPath.item])
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("detailController") as? DetailViewController
        
        if let detailController = detailController, let cell = cell{
            detailController.imageName = imageStrings[indexPath.item]
            detailController.transitioningDelegate = self
            detailController.delegate = self
            
            let startFrame = cell.convertRect(cell.bounds, toView: self.view)
            let finalFrame = CGRectMake(40, 170, 100, 100)
            
            transition.registerTransition(startFrame, finalRect: finalFrame, transitionView: cell)
            cell.hidden = true
            transitionCell = cell
            
            self.presentViewController(detailController, animated: true, completion: { 
                detailController.imageView.hidden = false
            })
        }
        
    }
}

extension ViewController: DetailViewControllerDelegate {
    func detailViewController(detailViewController: DetailViewController, didDismiss: Bool) {
        transition.finalFrame = detailViewController.imageView.convertRect(detailViewController.imageView.bounds, toView: detailViewController.view)
        detailViewController.imageView.hidden = true
        self.dismissViewControllerAnimated(true) { 
            self.transitionCell?.hidden = false
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresent = true
        return transition
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresent = false
        return transition
    }
    
}

//extension ViewController: UINavigationControllerDelegate {
//    
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//    }
//}