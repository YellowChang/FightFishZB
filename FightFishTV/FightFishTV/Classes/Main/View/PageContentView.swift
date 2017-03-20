//
//  PageContentView.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/6.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit

private let ContentCellID =  "ContentCellID"

protocol PageContentDelegate : class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class PageContentView: UIView {
    // MARK: 定义属性
    var startOffsetX : CGFloat = 0
    var childVCs : [UIViewController]
    weak var parentViewCtroller : UIViewController?
    weak var delegate: PageContentDelegate?
    var forbidScrollDelegate: Bool
    
    // MARK:- 懒加载属性
    lazy var collectionView: UICollectionView = {[weak self] in
        // 1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()

    // MARK: 自定义构造函数
    init(frame: CGRect, childVCs: [UIViewController] ,parentViewCtroller: UIViewController) {
        self.childVCs = childVCs
        self.parentViewCtroller = parentViewCtroller
        self.forbidScrollDelegate = false
        super.init(frame: frame)
        // 设置UI界面
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK:- 设置UI界面
extension PageContentView {
    func _setupUI() {
        // 1.将所有的子控制器添加到父控制器
        for childVC in childVCs {
           parentViewCtroller?.addChildViewController(childVC)
        }
        
        // 2.添加UICollectionView，用于在cell中存放控制器的View
        addSubview(self.collectionView)
        //如果frame是zero，只走numberOfItemsInSection代理方法，不走cellForItemAtindexPath代理方法
        collectionView.frame = bounds
    }
}

//MARK:-遵守UICollectionViewDataSource、UICollectionViewDelegate协议
extension PageContentView : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        // 2.给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        forbidScrollDelegate = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if forbidScrollDelegate {
            return
        }
        
        // 1.定义需要获取的数据
        var progress : CGFloat = 0
        var soureIndex : Int = 0
        var targetIndex : Int = 0

        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX {
            // 左滑
            // 1.计算progress 商 - 整数 = 小数
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            soureIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = soureIndex + 1
            
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
        }else{
            //右滑
            // 1.计算progress 1- (商 - 整数) = 1 - 小数
            progress = 1.0 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算soureIndex
            soureIndex = targetIndex + 1
            
            if soureIndex >= childVCs.count {
                soureIndex = childVCs.count - 1
            }
            
        }
        guard progress == 0 else {
            delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: soureIndex, targetIndex: targetIndex)
            return
        }
        
    }
}

//MARK: -对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex:Int) {
        forbidScrollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}



























