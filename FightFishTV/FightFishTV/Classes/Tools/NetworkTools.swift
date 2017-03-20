//
//  NetworkTools.swift
//  FightFishTV
//
//  Created by HuangChang on 17/3/7.
//  Copyright © 2017年 黄畅. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func requestData(type: MethodType, urlStr: String, parameters: [String : String]? = nil, finishedCallback : @escaping (Any) -> Void){
        // 1.获取数据
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        // 2.发送网络请求
        Alamofire.request(urlStr, method: method, parameters: parameters).responseJSON { (response) in
            // 3.获取数据
            guard let result = response.result.value else{
                print(response.result.error ?? "")
                return
            }
            finishedCallback(result)
        }
    }
    
}
