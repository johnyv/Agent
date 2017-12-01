//
//  requestParam.swift
//  Agent
//
//  Created by 于劲 on 2017/11/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class RequestBody: NSObject{
    var body:[String:[String:Any]] = [:]
    init(data:Dictionary<String, Any>){
        var param:[String:Any] = [:]
        param["sid"] = "123456789"
        param["data"] = data
        body["body"] = param
        var header:[String:Any] = [:]
        
        header["apiLevel"] = "100"
        header["encode"] = "UTF-8"
        header["platformId"] = "4"
        header["osType"] = "4"
        header["deviceToken"] = "token"
        header["model"] = UIDevice.current.model
        header["time"] = Int(Date().timeIntervalSince1970)
        header["userId"] = "user"
        header["sso_tk"] = getSavedToken()
        header["from"] = "hunan_db"
        header["mac"] = "mac"

        body["header"] = header
    }    
}
