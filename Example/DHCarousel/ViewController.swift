//
//  ViewController.swift
//  DHCarousel
//
//  Created by DolphinQuan on 07/24/2017.
//  Copyright (c) 2017 DolphinQuan. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var imageArray:[UIImage] = []
    var circleView:DHCarousel!
    
    override func viewDidLoad() {
        for i in 0...4 {
            imageArray.append(UIImage(named: "\(i)")!)
        }
        
        let frame = CGRect(x: 0, y: 64, width: screenWidth, height: 250)
        circleView = DHCarousel(frame, images: imageArray,time: 3)
        circleView.pageControl.center = CGPoint(x: self.view.center.x, y: 64 + 10)
        circleView.delegate = self
        
        self.view.addSubview(circleView)
    }
    @IBAction func btnClick(_ sender: UIButton) {
        circleView.imageArray = [imageArray.first!,imageArray.last!]
    }

}



extension ViewController:DHCarouselDelegate{
    func circleViewDidSelected(circleView: UIView, index: Int) {
        print(index)
    }
}
