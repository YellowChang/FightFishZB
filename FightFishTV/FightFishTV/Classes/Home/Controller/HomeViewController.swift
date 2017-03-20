//
//  HomeViewController.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/6.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    // MARK:- 懒加载属性
    lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.backgroundColor = UIColor.clear
        titleView.delegate = self
        return titleView
    }()
    
    //防止循环引用
    lazy var pageContentView : PageContentView = {[weak self] in
        // 1.确定内容的frame
       let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBarH
       let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        // 2.确定所有的子控制器
        var childVCs = [UIViewController]()
        childVCs.append(RecommendViewController())
        for _ in 1..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVCs: childVCs, parentViewCtroller: self!)
        contentView.delegate = self
        
        return contentView
    }()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 设置UI界面
        _setupUI()
        
//        NetworkTools.requestData(type: .POST
//        , urlStr: "http://httpbin.org/post", parameters: ["name":"huangchang"]) { (result) in
//            print(result)
//        }
    }

}
//MARK:- 设置UI界面
extension HomeViewController{
    func _setupUI(){
        // 0.不需要调整UISCrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.设置导航栏
        _setupNavigationBar()
        
        // 2.添加TitleView
        view.addSubview(pageTitleView)
        
        // 3.添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    private func _setupNavigationBar(){
        // 1.设置左侧的item
        let btn = UIButton()
        btn.setImage(UIImage(named:"logo"), for: .normal)
        //设置btn的尺寸根据图片自适应
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        // 2.设置右侧的item
        let size = CGSize(width: 40, height: 40)
                
        let historyItem = UIBarButtonItem.init(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}

//MARK: -遵守PageTitleViewDelegate协议
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleView(titleView:PageTitleView,selectedIndex index : Int){
        self.pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//MARK: -遵守PageTitleViewDelegate协议
extension HomeViewController : PageContentDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(contentView: contentView, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}





















