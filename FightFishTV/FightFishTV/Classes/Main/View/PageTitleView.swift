//
//  PageTitleView.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/6.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
// MARK:- 定义协议
//class表示该协议只能被类遵守
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView:PageTitleView,selectedIndex index : Int)
}

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85.0, 85.0, 85.0)
let kSelectedColor : (CGFloat, CGFloat, CGFloat) = (255.0, 128.0, 0)


class PageTitleView: UIView {
    // MARK: 定义属性
    var currentLabelIndex : Int = 0
    var titles: [String]
    weak var delegate : PageTitleViewDelegate?
    
    // MARK:- 懒加载属性
    lazy var titleLables: [UILabel] = [UILabel]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        return scrollLine
    }()
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame:frame)
        
        // 设置UI界面
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//MARK:- 设置UI界面
extension PageTitleView{
     func _setupUI() {
        // 1.添加ScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2. 添加title对应的label
        _setupTitleLabel()
        
        // 3.设置底线和滚动的滑块
        _setupBottomLineAndScrollLine()
        
    }
    private func _setupTitleLabel() {
        
        // 0.确定label的一些frame值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let lableH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0

        for (index,title) in titles.enumerated() {
            // 1.创建label
            let label = UILabel()
            
            // 2.设置label的属性
            label.text = title
            label.tag = index
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16.0)
            
            // 3.设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: lableH)
            
            // 4.将label添加到ScrollView
            scrollView.addSubview(label)
            
            // 5.将label放到titleLables数组中
            titleLables.append(label)
            
            // 6.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
            
        }
    }
    private func _setupBottomLineAndScrollLine() {
        // 1.添加底线
        let bottonLine = UIView()
        bottonLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottonLine.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: lineH)
        addSubview(bottonLine)
        
        // 2.添加scrollLine
        // 2.1 获取第一个label
        guard let firstLabel = titleLables.first else {
            return
        }
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollView.addSubview(scrollLine)

    }
}
//MARK: -监听label的点击
extension PageTitleView{
    @objc func titleLabelClick(tapGes:UITapGestureRecognizer){
        // 0.获取当前label的下标值
        guard let currentLabel = tapGes.view as? UILabel else {
            return
        }
        
        // 1.如果点击同一个则返回
        if currentLabel.tag == currentLabelIndex { return }
        
        // 2.获取之前label的下标值
        let lastLabel = titleLables[currentLabelIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        lastLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4.保存最新label的下标值
        currentLabelIndex = currentLabel.tag
        
        // 5.滚动条位置改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.5) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentLabelIndex)
        
    }
}

//MARK: -对外暴露的方法
extension PageTitleView{
    func setTitleWithProgress(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        // 1.取出source、targetLabel
        let sourceLabel = titleLables[sourceIndex]
        let targetLabel = titleLables[targetIndex]
        
        // 2.处理滑块的速度
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        UIView.animate(withDuration: 0.3) { 
            self.scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        }
        
        // 3.颜色渐变
        // 3.1.取出变化的范围
        let colorDelta = (kSelectedColor.0 - kNormalColor.0, kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kNormalColor.2)
        
        // 3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progress, g: kSelectedColor.1 - colorDelta.1 * progress, b: kSelectedColor.2 - colorDelta.2 * progress)
        
        // 3.3 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        currentLabelIndex = targetIndex
        
    }
}


























