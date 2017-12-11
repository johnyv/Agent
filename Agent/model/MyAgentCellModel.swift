//
//  MyAgentCellModel.swift
//  Agent
//
//  Created by 于劲 on 2017/12/11.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class MyAgentCellModel: NSObject {
    var agentId:Int?
    var headerImgSrc:String?
    var nickName:String?
    var agentType:String?
    var agentCard:Int?
    var lastBuyTime:String?
    init(agentId:Int, headerImgSrc:String, nickName:String, agentType:String, agentCard:Int, lastBuyTime:String) {
        self.agentId = agentId
        self.headerImgSrc = headerImgSrc
        self.nickName = nickName
        self.agentType = agentType
        self.agentCard = agentCard
        self.lastBuyTime = lastBuyTime
    }
}
