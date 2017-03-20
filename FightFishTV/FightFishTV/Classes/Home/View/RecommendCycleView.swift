//
//  RecommendCycleView.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/15.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
private let kCycleCell = "kCycleCell"
class RecommendCycleView: UIView {
    //MARK:- 控件属性
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK:- 属性
    var cycleTimer: Timer?
    var cycleGroup: [CycleModel]? {
        didSet{
            collectionView.reloadData()
            pageControl.numberOfPages = cycleGroup?.count ?? 0
            // 将collectionView滑到中间某个位置，实现轮播的第一个向前滑到最后一个的特效
            collectionView.scrollToItem(at: IndexPath.init(row:( cycleGroup?.count ?? 0) * 30, section: 0), at: .left, animated: false)
            
            // 添加定时器，实现自动无限轮播
            removeCycleTimer()
            addCycleTimer()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .init(rawValue: 0)
        collectionView.register(UINib.init(nibName: "RecommendCollectionCell", bundle: nil), forCellWithReuseIdentifier: kCycleCell)
        

    }
    override func layoutSubviews() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size

    }
}

// MARK:- 提供一个创建View的类方法
extension RecommendCycleView{
    class func recommendCycleView() -> RecommendCycleView {
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
        
    }
}
// MARK:-CollectionView 数据源和代理方法
extension RecommendCycleView: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        //乘以1000的作用：利用collectionView复用特性实现无限轮播
        return (cycleGroup?.count ?? 0) * 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCell, for: indexPath) as! RecommendCollectionCell
        cell.cycleModel = cycleGroup?[indexPath.row % (cycleGroup?.count ?? 1)]
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.contentOffset.x  + scrollView.bounds.size.width * 0.5)
        self.pageControl.currentPage = Int(offsetX / scrollView.bounds.size.width) % (cycleGroup?.count ?? 1)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 当用户拖拽时，停止定时器
        removeCycleTimer()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 当用户停止拖拽时，打开定时器
        addCycleTimer()
    }
}

// MARK:定时器操作
extension RecommendCycleView{
    func addCycleTimer() {
        cycleTimer = Timer.init(timeInterval: 3.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: .commonModes)
    }
    func removeCycleTimer() {
        cycleTimer?.invalidate()
        cycleTimer = nil
    }
    @objc private func timerAction() {
        let offsetX = collectionView.contentOffset.x + collectionView.bounds.size.width
        collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }
}



