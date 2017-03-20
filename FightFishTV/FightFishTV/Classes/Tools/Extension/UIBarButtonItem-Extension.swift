//
//  UIBarButtonItem-Extension.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/6.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
//    // 类函数
//    class func createItem(imageName: String, highImageName: String, size:CGSize) -> UIBarButtonItem{
//        let btn = UIButton()
//        btn.setImage(UIImage(named:imageName), for: .normal)
//        btn.setImage(UIImage(named:highImageName), for: .highlighted)
//        btn.frame = CGRect(origin: CGPoint.zero, size: size)
//        
//        return UIBarButtonItem(customView: btn)
//    }
    // 便利构造函数:1> convenience开头 2> 在构造函数中必须明确调用一个设计的构造函数
    convenience init(imageName: String, highImageName: String = "", size:CGSize = CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        
        if highImageName != "" {
            btn.setImage(UIImage(named:highImageName), for: .highlighted)
        }

        if size == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView: btn)
    }
}












