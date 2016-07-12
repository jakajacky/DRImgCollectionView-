//
//  ViewController.swift
//  DRImgCollectionView_Swift
//
//  Created by xqzh on 16/7/6.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var arr = NSMutableArray(capacity: 4)
        for i in 0..<4 {
            let img = UIImage(named: "image\(i)")
            arr.addObject(img!)
        }
        
        let im = DRImgCollectionView(frame: CGRectMake(0, 0, 375, 200), imgs: arr, dotColor: UIColor.grayColor(), dotSize: 15)
        
        im.setAttributeList(UICollectionViewScrollDirection.Horizontal, location: PageControlLoc.PageControlLocRight, dotImage: UIImage(named: "normalDotImg")!, currentDotImage: UIImage(named: "currentDotImg")!, backgroundColor: UIColor.clearColor())
        
        self.view.addSubview(im)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

