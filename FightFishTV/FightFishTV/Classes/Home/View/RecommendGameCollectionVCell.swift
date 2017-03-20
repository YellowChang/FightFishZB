//
//  RecommendGameCollectionVCell.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/15.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendGameCollectionVCell: UICollectionViewCell {
    //MARK: 控件属性
    @IBOutlet weak var imageView: UIImageView!
    // 注意一个ImageView以一个Label设置约束的话，那么这个Label必须添加高度约束，否则ImageView显示图片不正常
    @IBOutlet weak var titleLabel: UILabel!
    //MARK: 模型属性
    var group: AnchorGroup? {
        didSet{
            titleLabel.text = group?.tag_name
            if let url = URL(string: group?.icon_url ?? ""){
                let imageResoure = ImageResource(downloadURL: url)
                
                imageView.kf.setImage(with: imageResoure, placeholder: Image(named: "home_more_btn"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                imageView.image = Image(named: "home_more_btn")
            }
            
           
        }
    }
    
}
