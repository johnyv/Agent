//
//  requestParam.swift
//  Agent
//
//  Created by 于劲 on 2017/11/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import AdSupport

class RequestBody: NSObject{
    var body:[String:[String:Any]] = [:]
    init(data:Dictionary<String, Any>){
        var param:[String:Any] = [:]
        let agent = AgentSession.shared.agentModel
        
        let timeInterVal = Int(Date().timeIntervalSince1970*1000)

        param["sid"] = timeInterVal
        param["data"] = data
        body["body"] = param
        var header:[String:Any] = [:]
        
        header["apiLevel"] = "100"
        header["encode"] = "UTF-8"
        header["platformId"] = UIDevice.current.systemVersion
        header["osType"] = "4"
        header["deviceToken"] = "token"
        header["model"] = UIDevice.current.model
        header["time"] = Int(Date().timeIntervalSince1970)
        header["userId"] = UserDefaults.standard.string(forKey: "uid")
        header["sso_tk"] = getSavedToken()
        header["from"] = agent?.serverCode
        header["mac"] = "forbidden"
        header["udid"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        body["header"] = header
    }    
}
