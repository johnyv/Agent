//
//  ErrorMessage.swift
//  Agent
//
//  Created by 于劲 on 2017/11/16.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
class ErrorMessage: NSObject {
    var msg = Dictionary<Int, String>()
    override init() {
        msg = [:]
        msg[15001] = "用户名密码错误"
        msg[15002] = "验证码错误"
        msg[15004] = "token失效，请重新登录。"
        msg[15003] = "手机号不存在"
        msg[15005] = "短信发送次数超限，请明天再来"
    }
    
    func desc(key:Int) -> (String) {
        return msg[key]!
    }
}

let errMsg = ErrorMessage()
