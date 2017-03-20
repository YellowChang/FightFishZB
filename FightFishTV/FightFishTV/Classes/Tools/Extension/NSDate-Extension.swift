//
//  NSDate-Extension.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/13.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import Foundation
extension NSDate{
    class func getCurrentTime() -> (String){
        let interval = Int(NSDate().timeIntervalSince1970)
        return "\(interval)"
    }
}
