//
//  PrettyCollectionViewCell.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/11.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit

class PrettyCollectionViewCell: BaseCollectionCell {
    @IBOutlet weak var locationBtn: UIButton!
    override var anchor: AnchorModel?{
        didSet{
            super.anchor = anchor
            locationBtn.setTitle(anchor?.anchor_city, for: .normal)
        }
    }
}
