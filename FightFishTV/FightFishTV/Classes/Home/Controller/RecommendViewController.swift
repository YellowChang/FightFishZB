//
//  RecommendViewController.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/11.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
private let kItemMargin: CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 2 / 3
private let kPrettyItemH = kItemW * 1.2
private let kHeaderH: CGFloat = 50
private let kRecommendCycleH : CGFloat = kScreenW * 3 / 8
private let kRecommendGameH : CGFloat = 90
private let kNormalCellIdentifier = "NormalCellIdentifier"
private let kPrettyCellIdentifier = "PrettyCellIdentifier"

private let kHeaderIdentifier = "HeaderIdentifier"

class RecommendViewController: UIViewController {
    // MARK: - 懒加载属性
    lazy var collectionView: UICollectionView = {[unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
//        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderH)
        layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin, 0, kItemMargin)
        
        var collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "NormalCollectionCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellIdentifier)
        collectionView.register(UINib(nibName: "PrettyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellIdentifier)
        collectionView.register(UINib(nibName: "SectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.backgroundColor = UIColor.white

        
        return collectionView
    }()
    
    //轮播图
    lazy var recommendCycleView: RecommendCycleView = {
        let recommendCycleView = RecommendCycleView.recommendCycleView()
        recommendCycleView.frame = CGRect(x: 0, y: -(kRecommendCycleH + kRecommendGameH), width: kScreenW, height: kRecommendCycleH)
       return recommendCycleView
    }()
    
    //游戏推荐界面
    lazy var recommendGameView: RecommendGameView = {
        let recommendGameView = RecommendGameView.recommendGameView()
        recommendGameView.frame = CGRect(x: 0, y: -kRecommendGameH, width: kScreenW, height: 90)
        return recommendGameView
    }()
    
    //模型对象
    lazy var recommendVM = RecommendViewModel()

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI
        _setupUI()
        
        //网络请求
        // 1.推荐数据
        recommendVM.requestData {
            self.collectionView.reloadData()
            self.recommendGameView.groups = self.recommendVM.anchorGroups
        }
        // 2.轮播数据
        recommendVM.requestCycleData {
            self.recommendCycleView.cycleGroup = self.recommendVM.cycleGroup
        }
    }

}
// MARK: - 设置UI
extension RecommendViewController{
    func _setupUI() {
        view.addSubview(collectionView)
        collectionView.addSubview(recommendCycleView)
        collectionView.addSubview(recommendGameView)
        collectionView.contentInset = UIEdgeInsetsMake(kRecommendCycleH + kRecommendGameH, 0, 0, 0)
    }
}
// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension RecommendViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return recommendVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return recommendVM.anchorGroups[section].roomList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        var cell : BaseCollectionCell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellIdentifier, for: indexPath) as! BaseCollectionCell
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellIdentifier, for: indexPath) as! BaseCollectionCell
        }
        cell.anchor = recommendVM.anchorGroups[indexPath.section].roomList[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderIdentifier, for: indexPath) as! SectionHeaderReusableView
        header.headergroup = recommendVM.anchorGroups[indexPath.section]
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if indexPath.section == 1 {
            return  CGSize(width: kItemW, height: kPrettyItemH)
        }
        return  CGSize(width: kItemW, height: kNormalItemH)
    }
}




