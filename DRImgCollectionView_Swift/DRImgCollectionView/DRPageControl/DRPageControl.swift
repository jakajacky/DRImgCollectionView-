//
//  DRPageControl.swift
//  DRPageControl_Swift
//
//  Created by xqzh on 16/7/6.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit
import CoreGraphics

let kDefaultNumberOfPages          = 0
let kDefaultCurrentPage            = -1
let kDefaultHideForSinglePage      = true
let kDefaultShouldResizeFromCenter = true
let kDefaultSpacingBetweenDots     = 8
let kDefaultDotSize                = 8
let kDefaultDotColor               = UIColor.whiteColor()
var scale:CGFloat = 1.4

class DRPageControl: UIControl {

    var dotImage:UIImage? {
        didSet {
            // 设置dot 图片
            setDotImage()
        }
    }
    var currentDotImage:UIImage? {
        didSet {
            setCurrentDotImage()
        }
    }
    var dotSize:Int? {
        didSet {
            // 设置dot 大小
            setDotsSize()
        }
    }
    var dotColor:UIColor? {
        didSet {
            // 设置dot 颜色
            setDotsColor()
        }
    }
    var spacingBetweenDots:Int?
    var numberOfPages:Int? {
        didSet {
            // 设置dot views
            setUpDots()
        }
    }
    var currentPage:Int {
        didSet {
            // 设置选中状态
            setSeclectedDot()
        }
    }
    var hidesForSinglePage:Bool
    var shouldResizeFromCenter:Bool?
    var dots:NSMutableArray
    
    var width:CGFloat
    var height:CGFloat
    
    
    override init(frame: CGRect) {

        width  = 0.0
        height = 0.0
        
        spacingBetweenDots     = kDefaultSpacingBetweenDots
        currentPage            = kDefaultCurrentPage
        hidesForSinglePage     = kDefaultHideForSinglePage
        shouldResizeFromCenter = kDefaultShouldResizeFromCenter
        dotSize                = kDefaultDotSize
        dotColor               = kDefaultDotColor
        dots                   = NSMutableArray()
        super.init(frame: frame)
        
        numberOfPages = kDefaultNumberOfPages
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置dots view
    func setUpDots() {
        
        width  = frame.width
        height = frame.height
        
        let realWidth = (numberOfPages! - 1) * spacingBetweenDots! + numberOfPages! * self.dotSize!
        let startX    = (width - CGFloat(realWidth)) / 2
        let startY    = (height - CGFloat(self.dotSize!)) / 2
                
        for  i in 0..<numberOfPages! {
            
            let x = startX + CGFloat(i * (spacingBetweenDots! + dotSize!))
            var view:UIView
            if dots.count == numberOfPages! {
                view = dots[i] as! UIView
                view.frame = CGRectMake(x, startY, CGFloat(dotSize!), CGFloat(dotSize!))
                view.backgroundColor = UIColor.clearColor()
                view.layer.cornerRadius = CGFloat(dotSize!) / 2
                view.layer.borderColor = dotColor!.CGColor
                
                view.layer.borderWidth = 1
                print("\(view)++++++\(CGRectMake(x, startY, CGFloat(dotSize!), CGFloat(dotSize!)))")
            }
            else {
            
                view = UIView(frame: CGRectMake(x, startY, CGFloat(dotSize!), CGFloat(dotSize!)))
                view.backgroundColor = UIColor.clearColor()
                view.layer.cornerRadius = CGFloat(dotSize!) / 2
                view.layer.borderColor = dotColor!.CGColor
                self.addSubview(view)
                dots.addObject(view)
                
                view.layer.borderWidth = 1
                
            }
            
            // 只有一页时 隐藏dot
            if hidesForSinglePage && numberOfPages == 1 {
                view.hidden = true
            }
            
        }
        
        // 默认选中第一个
        currentPage = 0
    }
    
    // 更新
    func updateViews() {
        
        let realWidth = (numberOfPages! - 1) * spacingBetweenDots! + numberOfPages! * self.dotSize!
        let startX    = (width - CGFloat(realWidth)) / 2
        let startY    = (height - CGFloat(self.dotSize!)) / 2
        
        var i = 0
        for dot in dots {
            let x = startX + CGFloat(i * (spacingBetweenDots! + dotSize!))
            let view:UIView = dot as! UIView
            view.frame = CGRectMake(x, startY, CGFloat(dotSize!), CGFloat(dotSize!))
            view.backgroundColor = UIColor.clearColor()
            view.layer.cornerRadius = CGFloat(dotSize!) / 2
            view.layer.borderColor = dotColor!.CGColor
    
            i += 1
            guard let dotImg = dotImage else {
                view.layer.borderWidth = 1
        
                break
            }
//            view.layer.borderWidth = 0
            
            
        }
        
        setSeclectedDot()
    }
    
    // 设置dot 图片
    func setDotImage() {
        for dot in dots {
            let view:UIView = dot as! UIView
            
            guard let dotImg = dotImage else {
                
                break
            }
            let imgView = UIImageView(frame: view.bounds)
            imgView.image = dotImg
            view.addSubview(imgView)
            view.layer.borderWidth = 0
        }
//        updateViews()
    }
    
    func setCurrentDotImage() {
        updateViews()
//        setSeclectedDot()

    }
    
    // 设置dot 大小
    func setDotsSize() {
        let realWidth = (numberOfPages! - 1) * spacingBetweenDots! + numberOfPages! * self.dotSize!
        let startX    = (width - CGFloat(realWidth)) / 2
        let startY    = (height - CGFloat(self.dotSize!)) / 2
        
        var i = 0
        for dot in dots {
            let x = startX + CGFloat(i * (spacingBetweenDots! + dotSize!))
            let view:UIView = dot as! UIView
            
            if i == currentPage {
                view.transform = CGAffineTransformIdentity // 先恢复缩放，再重设frame，不然不准确
            }
            view.frame = CGRectMake(x, startY, CGFloat(dotSize!), CGFloat(dotSize!))
            view.layer.cornerRadius = CGFloat(dotSize!) / 2
            
            i += 1
        }
        
        // 更新
        updateViews()
    }
    
    // 设置dot 颜色
    func setDotsColor() {
        for dot in dots {
            let view:UIView = dot as! UIView
            
//            guard let dotImg = dotImage else {
//                view.layer.borderWidth = 0
//                return
//            }
            view.layer.borderColor = dotColor!.CGColor
        }
        
        // 更新
        updateViews()
    }
    
    // 设置选中状态
    func setSeclectedDot() {
        
        if dots.count == 0 {
            return
        }
        
        let realWidth = (numberOfPages! - 1) * spacingBetweenDots! + numberOfPages! * self.dotSize!
        let startX    = (width - CGFloat(realWidth)) / 2
        let startY    = (height - CGFloat(self.dotSize!)) / 2
        let x = startX + CGFloat(currentPage * (spacingBetweenDots! + dotSize!))
        
        // 当前dot 改变状态
        let view = dots[currentPage] as? UIView
        
        UIView.animateWithDuration(0.75,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: -20,
                                   options: UIViewAnimationOptions.CurveLinear ,
                                   animations:
            {
                guard let dotImg = self.currentDotImage else { // 是否设置了dotImage
                    view?.backgroundColor = self.dotColor!
                    view?.transform = CGAffineTransformMakeScale(scale, scale)
                    return
                }

                
                view?.transform = CGAffineTransformIdentity
                view?.frame = CGRectMake(x, startY, CGFloat(self.dotSize!), CGFloat(self.dotSize!))
                
                view?.backgroundColor = UIColor.clearColor()
                view?.layer.borderWidth = 0
                let imageView =  view?.subviews[0] as! UIImageView
                imageView.image = self.currentDotImage
                print("frame====\(view?.frame)")
            },
                                   completion: nil)
        

        // 其他dot 复原
        for index in 0..<numberOfPages! {

            if index != currentPage {
                let lastView = dots[index] as? UIView
                
                
                UIView.animateWithDuration(0.75,
                                           delay: 0,
                                           usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0,
                                           options: UIViewAnimationOptions.CurveLinear,
                                           animations:
                    {
                        guard let dotImg = self.dotImage else { // 是否设置了dotImage
                            lastView?.backgroundColor = UIColor.clearColor()
                            lastView?.transform = CGAffineTransformIdentity
                            return
                        }
                        
                        lastView?.transform = CGAffineTransformIdentity
                        lastView?.backgroundColor = UIColor.clearColor()
                        lastView?.layer.borderWidth = 0
                        let imageView =  lastView?.subviews[0] as! UIImageView
                        imageView.image = self.dotImage
                        
                        
                    },
                                           completion: nil)
            }
        }
        
        
    }
    

        
}
