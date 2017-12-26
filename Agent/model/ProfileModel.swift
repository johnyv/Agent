//
//  ProfileModel.swift
//  Agent
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation

@objc class ProfileModel: NSObject {

    var headerImgSrc: String = ""
    var nickName: String = ""
    var account: String = ""
    var agentId: Int = 0
    var gameName: String = ""
    var proofName:String = ""
    var bindTel:String = ""
    var weChatLogin:Bool = false
    var serverCity:String = ""
    var createTime:String = ""
    var cardCount:Int = 0
    var agentType:String = ""
    
    init(dic:[String: Any]) {
        super.init()
        setValuesForKeys(dic)
    }
}
