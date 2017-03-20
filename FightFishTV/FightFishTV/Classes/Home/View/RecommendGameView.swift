//
//  RecommendGameView.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/15.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit

private let kGameCell = "kGameCell"
class RecommendGameView: UIView {
    // MARK: 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: 模型属性
    var groups: [AnchorGroup]?{
        didSet{
            // 1.移出前两组
            groups?.removeFirst()
            groups?.removeFirst()
            // 2.添加更多组
            let group = AnchorGroup()
            group.tag_name = "更多"
            groups?.append(group)
            // 3.刷新数据
            collectionView.reloadData()
        }
    }
    
    // MARK:系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        //不随父控件的拉伸而拉伸
        autoresizingMask = .init(rawValue: 0)
        
        // 注册Cell
        collectionView.register(UINib.init(nibName: "RecommendGameCollectionVCell", bundle: nil), forCellWithReuseIdentifier: kGameCell)
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
}
// MARK:- 快速创建的类方法
extension RecommendGameView{
    class func recommendGameView() -> RecommendGameView{
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}

// MARK:- collection的数据源方法
extension RecommendGameView: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return groups?.count ?? 0
    }
  
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCell, for: indexPath) as! RecommendGameCollectionVCell
        cell.group = groups?[indexPath.row]
        return cell
    }
}
