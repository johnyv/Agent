//
//  AgentInfo.swift
//  Agent
//
//  Created by 于劲 on 2017/11/20.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

@objcMembers class AgentInfo: NSObject {
    
    var account: String?
    var agentId: Int = 0
    var roleId: Int = 0
    var name: String?
    var nickName: String?
    var headImg: String?
    var gameName: String?
    var serverCode: String?
    var lastBuyTime:String?
    var authorityList: [String]?
    
    init(dic:[String: Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
}
