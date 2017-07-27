//
//  XibController.swift
//  DHCarousel
//
//  Created by 全达晖 on 2017/7/25.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
class XibController: UIViewController {

    var imageArray:[UIImage] = []
    @IBOutlet weak var carouselView: DHCarousel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets =  false
        for i in 0...4 {
            imageArray.append(UIImage(named: "\(i)")!)
        }
        carouselView.times = 3     //可在代码设置也可在xib里面设置
        carouselView.imageArray = imageArray
        carouselView.pageControl.center = CGPoint(x: self.view.center.x, y: 64 + 10)
        
    }


}
