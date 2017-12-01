//
//  AgentInfo.swift
//  Agent
//
//  Created by 于劲 on 2017/11/20.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
//import ObjectMapper

class AgentInfo: NSObject {
    static let instance = AgentInfo()
    
    var account: String?
    var agentId: String?
//    var authorityList: [AnyObject]?
    var name: String?
    var headImg:String?
    var nickName: String?
    var roleId: String?
    var serverCode: String?
    var gameName: String?
    var lastBuyTime:String?
    
//    private init(){
//    }
//    
//    required init?(map: Map) {
//    }
//    
//    func mapping(map: Map) {
//        account <- map["account"]
//        agentId <- map["agentId"]
//        authorityList <- map["arr"]
//        name <- map["name"]
//        headImg <- map["headImg"]
//        nickName <- map["nickName"]
//        roleId <- map["roleId"]
//        serverCode <- map["serverCode"]
//        gameName <- map["gameName"]
//        lastBuyTime <- map["lastBuyTime"]
//    }
}
