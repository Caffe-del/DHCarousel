//
//  CircleView.swift
//  circleView
//
//  Created by 全达晖 on 2017/7/21.
//  Copyright © 2017年 全达晖. All rights reserved.
//

import UIKit

public let screenWidth = UIScreen.main.bounds.width
public let screenHeight = UIScreen.main.bounds.height

public protocol DHCarouselDelegate {
    func circleViewDidSelected(circleView:UIView,index:Int)
}

public class DHCarousel: UIView {

    /// 轮播的图片数组 触发属性观察器则会更新图片数据
    public var imageArray:[UIImage] {
        didSet{
            resetStatus()
            makeUI()
        }
    }
    /// 自动轮播的时间段
    public var times:TimeInterval
    public var delegate:DHCarouselDelegate?
    
    
    fileprivate var timer:Timer?
    fileprivate var currentPage = 0
    fileprivate var lastPosition:CGFloat = screenWidth
    
    fileprivate lazy var scrollView:UIScrollView = {
        var view:UIScrollView = UIScrollView(frame: self.bounds)
        view.isPagingEnabled = true
        view.backgroundColor = .red
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.contentSize = CGSize(width: CGFloat( self.imageArray.count) * screenWidth, height: self.bounds.size.height)
        return view
    }()
    
    fileprivate lazy var pageControl:UIPageControl = {
       var page = UIPageControl()
        page.pageIndicatorTintColor = .red
        page.currentPage = 0
        return page
    }()
    
    public init(_ frame:CGRect,images:[UIImage],time:TimeInterval){
        times = time
        imageArray = images
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override  public func didMoveToSuperview() {
        makeUI()
    }
    
    fileprivate func resetStatus(){
        removeTimer()
        for view in subviews {
            view.removeFromSuperview()
        }
        currentPage = 0
        pageControl.currentPage = 0
    }
    
    fileprivate func makeUI(){
        //创建图片
        func creatImageView(frame:CGRect,image:UIImage,tag:Int) -> UIImageView{
            let imageView = UIImageView(frame:frame)
            imageView.image = image
            imageView.tag = tag
            imageView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelect(pan:)))
            imageView.addGestureRecognizer(gesture)
            return imageView
        }
        addSubview(scrollView)
        
        for (index,element) in imageArray.enumerated() {
            let indexNew = imageArray.count > 1 ? index + 1: index  //images 数组大于一个的时候，需要在前后添加一个图片，做循环轮播
            let frame = CGRect(x: (CGFloat(indexNew) * screenWidth), y: 0, width: screenWidth, height: self.bounds.height)
            scrollView.addSubview(creatImageView(frame: frame, image: element,tag: index))
        }
        if imageArray.count > 1 {
            //添加最后一个图片
            let bottomImageframe = CGRect(x: (CGFloat(imageArray.count + 1) * screenWidth), y: 0, width: screenWidth, height: self.bounds.height)
            scrollView.addSubview(creatImageView(frame: bottomImageframe, image: imageArray.first!,tag: 0))
            //添加第一个图片
            let topImageframe = CGRect(x: 0, y: 0, width: screenWidth, height: self.bounds.height)
            scrollView.addSubview(creatImageView(frame: topImageframe, image: imageArray.last!,tag: imageArray.count - 1))
            //重新设置第一个图片的位置，及滚动区域
            scrollView.setContentOffset(CGPoint.init(x: screenWidth, y: 0), animated: false)
            scrollView.contentSize = CGSize(width: CGFloat( imageArray.count + 2) * screenWidth, height: self.bounds.size.height)
        }
        
        addSubview(pageControl)
        pageControl.numberOfPages = imageArray.count
        pageControl.center = CGPoint(x: self.center.x, y: self.bounds.size.height - 10)
        
        addTimer()
    }
    
    
    /// 添加定时器
    fileprivate func addTimer(){
        guard imageArray.count > 1 else {
            pageControl.isHidden = true
            return
        }
        timer = Timer(timeInterval: times, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    fileprivate func removeTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    
    /// 滚动到下一页
    @objc fileprivate func scrollToNextPage(){
        currentPage += 1
        let pointX = CGFloat(currentPage + 1) * screenWidth //多了前面第一张图
        scrollView.setContentOffset(CGPoint(x: pointX, y: 0), animated: true)
        pageControl.currentPage = currentPage
    }
    
    @objc fileprivate func didSelect(pan:UITapGestureRecognizer){
        guard let delegate = self.delegate  else {
            return
        }
        delegate.circleViewDidSelected(circleView: self, index: pan.view!.tag)
    }
}


extension DHCarousel:UIScrollViewDelegate {
     final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
     final public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    final public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //解决自动轮播下，最后一张跳到第一张图片后，立即使用手势拖拽出现的空白页面情况
        if currentPage == imageArray.count{
            currentPage = 0
            pageControl.currentPage = currentPage
            scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
        }
    }
    //处理手势结束
    final public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width;
        let fractionalPage = scrollView.contentOffset.x / pageWidth;
        let page = Int(fractionalPage);
        
        if page == imageArray.count + 1 {
            scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
            pageControl.currentPage = 0
            currentPage = 0
        }
        else if page == 0 {
            scrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat( imageArray.count), y: 0), animated: false)
            currentPage = imageArray.count - 1
            pageControl.currentPage = imageArray.count - 1
        }
        else{
            pageControl.currentPage = page - 1
            currentPage = page - 1
        }
    }
}

