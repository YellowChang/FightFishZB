//
//  WebModel.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/14.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
class WebModel: NSObject {
    // MARK: 构造函数
    override init() {
        super.init()
    }
    init(dic: [String : NSObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    override func setNilValueForKey(_ key: String) {}
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

class AnchorGroup: WebModel {
    // 1.该组中对应的房间信息
    // 定义room_list模型对象数组
    lazy var roomList : [AnchorModel] = [AnchorModel]()
    //注意不能定义为private，否则不会进入didSet方法
    var room_list : [[String : NSObject]]?{
        didSet{
            guard let room_list = room_list else { return }
            for dicItem in room_list {
                let roomItem = AnchorModel(dic: dicItem)
                roomList.append(roomItem)
            }
        }
    }
    // 2.组显示的标题
    var tag_name : String = ""
    // 3.组显示的图标
    var icon_name : String = "home_header_normal"
    // 4.游戏对象的图标
    var icon_url : String = ""
    
}

class AnchorModel: WebModel {
    // 1.房间ID
    var room_id : Int = 0
    // 2.房间图片对应的url
    var vertical_src : String = ""
    // 3.判断房间是手机直播: 1 还是电脑直播: 0
    var isVertical = 0
    // 4.房间name
    var room_name : String = ""
    // 5.主播昵称
    var nickname : String = ""
    // 6.在线观看人数
    var online : Int = 0
    // 7.所在城市
    var anchor_city : String = ""
    
 
}
class CycleModel: WebModel {
    // 1.title
    var title : String = ""
    // 2.展示图片地址
    var pic_url : String = ""
    // 3.room
    lazy var roomInfo : AnchorModel = AnchorModel()
    var room : [String : NSObject]?{
        didSet{
            guard let room = room else {
                return
            }
            roomInfo = AnchorModel(dic: room)
        }
    }
    
    
    
}
