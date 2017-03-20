//
//  RecommendViewModel.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/13.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit

class RecommendViewModel {
    // MARK:- 懒加载属性
    // 2-12组数据
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    lazy var prettyGroup : AnchorGroup = AnchorGroup()
    lazy var cycleGroup : [CycleModel]  = [CycleModel]()
    
}
// MARK:- 发送网络请求
extension RecommendViewModel{
    // 1.请求推荐数据
    func requestData(finishedCallBack : @escaping () -> ()) {
        // 0.定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime()]
//        let parameters = ["limit" : "4", "offset" : "0"]

        // 1.创建组
        let dGroup = DispatchGroup.init()
        
        
        /* 2.请求第一部分推荐数据
             https://capi.douyucdn.cn/api/v1/getbigDataRoom
         */
        // 0.进入组
        dGroup.enter()
        NetworkTools.requestData(type: .GET, urlStr: "https://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters:["time" : NSDate.getCurrentTime()]) { (result) in
            // 1.将结果转换成字典
            guard let resultDic = result as? [String : NSObject] else { return }
            // 2.根据字典中的key:data获取对应数组
            guard let resultArr = resultDic["data"] as? [[String : NSObject]] else { return }
            // 3.遍历数组，获取字典，将字典转换成模型对象
            // 3.1 设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            // 3.2 获取主播数据
            for dicItem in resultArr {
                let anchorModel = AnchorModel(dic: dicItem)
                self.bigDataGroup.roomList.append(anchorModel)
            }

            // 离开组
            dGroup.leave()
//            print("获取0组数据")
        }
        
        /* 3.请求第二部分颜值数据
             https://capi.douyucdn.cn/api/v1/getVerticalRoom?limit=4&offset=0
         */
        // 0.进入组
        dGroup.enter()
        NetworkTools.requestData(type: .GET, urlStr: "https://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            // 1.将结果转换成字典
            guard let resultDic = result as? [String : NSObject] else { return }
            // 2.根据字典中的key:data获取对应数组
            guard let resultArr = resultDic["data"] as? [[String : NSObject]] else { return }
            // 3.遍历数组，获取字典，将字典转换成模型对象
            // 3.1 设置组的属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "columnYanzhiIcon"
            // 3.2 获取主播数据
            for dicItem in resultArr {
                let anchorModel = AnchorModel(dic: dicItem)
                self.prettyGroup.roomList.append(anchorModel)
            }
            // 离开组
            dGroup.leave()
//            print("获取1组数据")
        }
        
        /* 4.请求后面部分游戏数据
             https://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0
         */
        // 0.进入组
        dGroup.enter()
        NetworkTools.requestData(type: .GET, urlStr: "https://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            // 1.将结果转换成字典
            guard let resultDic = result as? [String : NSObject] else { return }
            // 2.根据字典中的key:data获取对应数组
            guard let resultArr = resultDic["data"] as? [[String : NSObject]] else { return }
            // 3.遍历数组，获取字典，将字典转换成模型对象
            for dicItem in resultArr {
                let group = AnchorGroup(dic: dicItem)
                group.icon_name = "home_header_normal"
                self.anchorGroups.append(group)
            }
            //移出颜值那组数据
            self.anchorGroups.remove(at: 1)
            // 4.离开组
            dGroup.leave()
//            print("获取2-12组数据")
        }
        
        // 5.请求到所有数据，进行排序
        dGroup.notify(queue: DispatchQueue.main) {
//            print("获取所有数据")
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            self.anchorGroups.insert(self.prettyGroup, at: 1)
            finishedCallBack()
        }
    }
    
    // 2.请求轮播数据
    func requestCycleData(finishedCallBack : @escaping () -> ()){
        //  https://capi.douyucdn.cn/api/v1/slide/6&version:2.3000
        NetworkTools.requestData(type: .GET, urlStr: "https://capi.douyucdn.cn/api/v1/slide/6", parameters: ["version" : "2.460"]) { (result) in
            guard let resultDic = result as? [String : NSObject] else{ return }
            guard let resultArr = resultDic["data"] as? [[String : NSObject]] else { return }
            for dicItem in resultArr{
                let cycleModel = CycleModel(dic: dicItem)
                self.cycleGroup.append(cycleModel)
            }
            finishedCallBack()
        }
    }
}
















