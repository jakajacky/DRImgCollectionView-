//
//  DRImgCollectionViewCell.swift
//  DRImgCollectionView_Swift
//
//  Created by xqzh on 16/7/8.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class DRImgCollectionViewCell: UICollectionViewCell {
    
    var imgView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgView = UIImageView(frame: self.bounds)
        imgView!.backgroundColor = UIColor.cyanColor()
        self.contentView.addSubview(imgView!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
