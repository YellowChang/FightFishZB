//
//  SectionHeaderReusableView.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/11.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    var headergroup : AnchorGroup? {
        didSet{
           iconImageView.image = UIImage(named: headergroup?.icon_name ?? "home_header_normal")
            tagLabel.text = headergroup?.tag_name
        }
    }
}
