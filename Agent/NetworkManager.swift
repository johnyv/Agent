//
//  NetworkManager.swift
//  Agent
//
//  Created by 于劲 on 2017/11/16.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import Moya

//extension TargetType{
//    public var baseURL:URL{
//        return URL(string: "http://172.16.70.128:7010")!
//    }
//}

let NetProvider = MoyaProvider<NetworkManager>()

enum NetworkManager{
    case login(String, String) //用户账户密码登录接口
    case loginByMobile(String, String, String) //用户手机号登录接口
    case sms(String, String, Int) //获取手机短信验证码
    case refresh //刷新token接口
}

extension NetworkManager:TargetType{
    var baseURL:URL{
        return URL(string: "http://172.16.70.128:7010")!
    }

    var path:String{
        switch self{
        case .login(_,_):
            return "/api/auth/login"
        case .loginByMobile(_, _, _):
            return "/api/auth/loginByMobile"
        case .sms(_, _, _):
            return "/api/auth/sms"
        case .refresh:
            return "/api/auth/refresh"
        }
    }
    
    var method:Moya.Method{
        switch self {
        case .refresh:
            return .get
        default:
            return .post
        }
    }
    
    public var task:Task{
        switch self {
        case .login(let usr, let pwd):
            var params:[String:Any] = [:]
            params["username"] = usr//"18500206220"
            params["password"] = pwd//"Assassin1"
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var validate:Bool{
        return false
    }
    
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var headers:[String:String]?{
        return ["Content-Type" : "application/json"]
    }
}
