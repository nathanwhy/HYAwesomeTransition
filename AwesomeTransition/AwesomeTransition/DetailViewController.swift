//
//  DetailViewController.swift
//  AwesomeTransition
//
//  Created by why on 16/4/18.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate : NSObjectProtocol {
    func detailViewController(_ detailViewController: DetailViewController, didDismiss: Bool)
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?
    var imageName:String?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func close(_ sender: AnyObject) {
        self.imageView.isHidden = true
        self.delegate?.detailViewController(self, didDismiss: true)
    }
}
