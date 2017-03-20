//
//  BaseCollectionCell.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/14.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
import Kingfisher

class BaseCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var onLineBtn: UIButton!
    @IBOutlet weak var nickNameBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var anchor : AnchorModel? {
        didSet{
            guard let anchor = anchor else {
                return
            }
            
            var onlineStr = ""
            if anchor.online >= 10000 {
                onlineStr = "\(anchor.online / 10000)万"
            }else{
                onlineStr = "\(anchor.online)"
            }
            onLineBtn.setTitle(onlineStr, for: .normal)
            
            nickNameBtn.setTitle(anchor.nickname, for: .normal)
            
            guard let iconUrl = URL(string: anchor.vertical_src) else{ return }
            let resource = ImageResource.init(downloadURL: iconUrl)
            iconImageView.kf.setImage(with:resource)
            
        }
    }
}
