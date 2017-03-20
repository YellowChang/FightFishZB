//
//  RecommendCollectionCell.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/15.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendCollectionCell: UICollectionViewCell {
    // MARK: 控件属性
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //MARK: 模型属性
    var cycleModel : CycleModel? {
        didSet{
            titleLabel.text = cycleModel?.title
            imageView.kf.setImage(with: ImageResource(downloadURL:URL(string: cycleModel?.pic_url ?? "")!), placeholder: Image.init(named: "Img_default"), options: nil, progressBlock: nil, completionHandler: nil)
            
        }
    }
    

}
