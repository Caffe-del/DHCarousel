//
//  XibController.swift
//  DHCarousel
//
//  Created by 全达晖 on 2017/7/25.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import DHCarousel
class XibController: UIViewController {

    var imageArray:[UIImage] = []
    @IBOutlet weak var carouselView: DHCarousel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets =  false
        for i in 0...4 {
            imageArray.append(UIImage(named: "\(i)")!)
        }
        carouselView.times = 3
        carouselView.imageArray = imageArray
        
    }


}
