//
//  DRImgCollectionView.swift
//  DRImgCollectionView_Swift
//
//  Created by xqzh on 16/7/6.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

//let kWidth       = _imgViews.frame.size.width
//let kHeight      = _imgViews.frame.size.height


enum PageControlLoc {
    case PageControlLocCenter    // 底部居中
    case PageControlLocRight     // 底部靠右
    case PageControlLocRightSide // 侧边靠右
}

class DRImgCollectionView: UIView {
    
    var kWidth:CGFloat = 0.0
    var kHeight:CGFloat = 0.0
    
    // 时间器
    var _timer:NSTimer?
    // 指示器
    var _pageView:DRPageControl?
    // 图片视图
    var _imgViews:UICollectionView
    // 存放图片数组
    var _imgArray:NSMutableArray?
    
    // collectionView的布局和方向
    var _layout:UICollectionViewFlowLayout
    var _direction:UICollectionViewScrollDirection    // 默认水平滚动
   
    // 分页指示器属性
    var _pageControlLocation:PageControlLoc           // 位置，默认居中
    var _dotSize:Int                                  // 大小，默认10
    var _dotColor:UIColor                             // 颜色，默认白色
    var _dotImage:UIImage?                            // 其他点的图片，默认不设置
    var _currentDotImage:UIImage?                     // 当前点的图片，默认不设置
    var _backgroudColor: UIColor                      // 背景颜色，默认无
    
    var kMiddleIndex:Int
    
    override init(frame: CGRect) {
        _direction = .Horizontal                      // 水平滚动
        _pageControlLocation = .PageControlLocCenter  // 居中
        _dotSize = 10                                 // 直径10
        _dotColor = UIColor.whiteColor()              // 白色指示器
        _backgroudColor = UIColor.cyanColor()        // 无背景颜色
        _layout = UICollectionViewFlowLayout()
        _imgViews = UICollectionView(frame: frame, collectionViewLayout: _layout)
        kMiddleIndex = 0
        
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, imgs:NSArray, dotColor:UIColor, dotSize:Int) {
        self.init(frame:frame)
        
        kWidth = frame.size.width
        kHeight = frame.size.height
        
        _imgArray = NSMutableArray(array: imgs)
        _dotColor = dotColor
        _dotSize  = dotSize
        
        kMiddleIndex = imgs.count * 100
        
        // layout
        _layout.minimumLineSpacing = 0
        _layout.minimumInteritemSpacing = 0
        _layout.itemSize = CGSizeMake(frame.size.width, frame.size.height)
        _layout.scrollDirection = _direction
        
        // collectionView
        _imgViews = UICollectionView(frame: frame, collectionViewLayout: _layout)
        _imgViews.pagingEnabled = true
        _imgViews.delegate = self
        _imgViews.dataSource = self
        self.addSubview(_imgViews)
        
        // 注册
        _imgViews.registerClass(DRImgCollectionViewCell.self, forCellWithReuseIdentifier: "img")
        
        // 初始位置在中间
        _imgViews.scrollToItemAtIndexPath(NSIndexPath.init(forItem: kMiddleIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        
        // 分页指示器
        self.initPageControl()
        
        // timer
        _timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(run), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(_timer!, forMode: NSRunLoopCommonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化pageControl
    func initPageControl() {
        var frame:CGRect
        switch _pageControlLocation {
        case .PageControlLocCenter:
            frame = CGRectMake(0, kHeight - CGFloat(_dotSize) - 5, kWidth, CGFloat(_dotSize))
        case .PageControlLocRight:
            let rightWidth = CGFloat(((_imgArray?.count)! + 1) * 10 + (_imgArray?.count)! * _dotSize)
            frame = CGRectMake(kWidth - rightWidth, kHeight - CGFloat(_dotSize) - 5, rightWidth, CGFloat(_dotSize))
        case .PageControlLocRightSide:
            let rightWidth = CGFloat(((_imgArray?.count)! + 1) * 10 + (_imgArray?.count)! * _dotSize)
            frame = CGRectMake(0, 0, rightWidth, CGFloat(_dotSize))
            
        }
        
        if _pageView == nil {
            _pageView = DRPageControl(frame: frame)
        }
        else {
            _pageView?.frame = frame
        }
        _pageView?.numberOfPages = _imgArray?.count
        _pageView?.backgroundColor = _backgroudColor
        _pageView?.dotColor = _dotColor
        _pageView?.dotSize = _dotSize
        
        if _dotImage != nil {
            _pageView?.dotImage = _dotImage
        }
        if _currentDotImage != nil {
            _pageView?.currentDotImage = _currentDotImage
        }
        if _pageControlLocation == .PageControlLocRightSide {
            _pageView?.center = CGPointMake(kWidth - CGFloat(_dotSize), kHeight / 2)
            let trans:CGAffineTransform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            _pageView?.transform = trans
        }
        
        
        
        self.addSubview(_pageView!)
        
    }
    
    func setAttributeList(direction:UICollectionViewScrollDirection,
                          location:PageControlLoc,
                          dotImage:UIImage,
                          currentDotImage:UIImage,
                          backgroundColor:UIColor) {
        _direction              = direction
        _pageControlLocation    = location
        _dotImage              = dotImage
        _currentDotImage        = currentDotImage
        _backgroudColor        = backgroundColor
        
        // 更新pageControl
        self.initPageControl()
        
        // 更新collectionView滚动方式
        _layout.scrollDirection = _direction;
    }
    
    func run() {
        let cell = _imgViews.visibleCells()[0] as! DRImgCollectionViewCell
        let index = _imgViews.indexPathForCell(cell)
        
        let currentPage = ((index?.item)! + 1) % (_imgArray?.count)!
        if (index?.item)! + 1 <= (_imgArray?.count)! * 200 {
            _imgViews.scrollToItemAtIndexPath(NSIndexPath.init(forItem: (index?.item)! + 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
        }
        else { // collectionView到达尽头的最后一张，也就是image0，切换回 中间位置，继续显示image0，这样有个问题就是最后一张得image0显示的时间变为4s
            _imgViews.scrollToItemAtIndexPath(NSIndexPath.init(forItem: kMiddleIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
            
        }
        //pageController
        _pageView?.currentPage = currentPage
    }
    
}


// collectionView的delegate & dataSource
extension DRImgCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (_imgArray?.count)! * 200 + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("img", forIndexPath: indexPath) as! DRImgCollectionViewCell
        cell.imgView!.image = _imgArray?[(indexPath.item % (_imgArray?.count)!)] as? UIImage
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 当滚动停止时，如果此时滚动到首页，则将collectionView重置为中间位置
        let cell = _imgViews.visibleCells()[0] as! DRImgCollectionViewCell
        let index = _imgViews.indexPathForCell(cell)
        
        let currentPage = (index?.item)! % (_imgArray?.count)!
        if currentPage == 0 {
            _imgViews.scrollToItemAtIndexPath(NSIndexPath.init(forItem: kMiddleIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        }
//
        // 如果巧了，滚动停止时，没有一次位于首页，那么到最后一组的时候，将collectionView重置为中间位置
        if (index?.item)! == (_imgArray?.count)! * 200 - (_imgArray?.count)! {
            _imgViews.scrollToItemAtIndexPath(NSIndexPath.init(forItem: kMiddleIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        }
//
        // pageController
        _pageView?.currentPage = currentPage
//
        // 拖拽结束，collectionView停止下来2秒后 _timer继续
        self.performSelector(#selector(delay), withObject: nil, afterDelay: 2)
        print("+++++++++++++++\(index)")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // 手指滑动时，暂停时间器
        _timer?.pauseTimer()
    }
    
    func delay() {
        _timer?.resumeTimer()
    }

    
}



extension NSTimer {
    func pauseTimer() {
        if !self.valid {
            return
        }
        self.fireDate = NSDate.distantFuture()
    }
    
    func resumeTimer() {
        if !self.valid {
            return
        }
        self.fireDate = NSDate()
    }
}
