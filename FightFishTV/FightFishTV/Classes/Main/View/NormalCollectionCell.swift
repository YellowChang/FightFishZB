//
//  NormalCollectionCell.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/11.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit

class NormalCollectionCell: BaseCollectionCell {
    @IBOutlet weak var roomNameLabel: UILabel!
    override var anchor: AnchorModel?{
        didSet{
            super.anchor = anchor
            roomNameLabel.text = anchor?.room_name
        }
    }
}
