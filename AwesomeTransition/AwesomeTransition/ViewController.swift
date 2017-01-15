//
//  ViewController.swift
//  AwesomeTransition
//
//  Created by why on 16/4/18.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
    var imageStrings: [String] = []
    lazy var transition: AwesomeTransition = {
        let transition = AwesomeTransition()
        transition.containerBackgroundView = Bundle.main.loadNibNamed("ContainerView", owner: nil, options: nil)?.last as? UIView
        return transition
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...30 {
            imageStrings.append("doge")
        }
        imageStrings[10] = "doge2"
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.imageView.image = UIImage(named: imageStrings[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "detailController") as? DetailViewController
        
        if let detailController = detailController, let cell = cell{
            detailController.imageName = imageStrings[indexPath.item]
            detailController.transitioningDelegate = self
            detailController.delegate = self
            
            let startFrame = cell.convert(cell.bounds, to: self.view)
            let finalFrame = CGRect(x: 40, y: 170, width: 100, height: 100)
            
            self.transition.registerTransition(startFrame, finalRect: finalFrame, transitionView: cell)
            
            self.present(detailController, animated: true, completion: { 
                detailController.imageView.isHidden = false
                detailController.imageView.image = UIImage(named: self.imageStrings[indexPath.item])
            })
        }
        
    }
}

extension ViewController: DetailViewControllerDelegate {
    func detailViewController(_ detailViewController: DetailViewController, didDismiss: Bool) {
        transition.finalFrame = detailViewController.imageView.convert(detailViewController.imageView.bounds, to: detailViewController.view)
        detailViewController.imageView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresent = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
