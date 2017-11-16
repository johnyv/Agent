//
//  NetworkManager.swift
//  Agent
//
//  Created by 于劲 on 2017/11/16.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import Moya

extension TargetType{
    public var baseURL:URL{
        return URL(string: "http://172.16.70.128:7010")!
    }
}

let NetProvider = MoyaProvider<NetworkManager>(endpointClosure:endpointClosure)

enum NetworkManager{
    case login(String,String)
}

extension NetworkManager:TargetType{
//    var baseURL:URL{
//        return URL(string: "http://172.16.70.128:6010")!
//    }

    var path:String{
        switch self{
        case .login(_,_):
            return "/api/auth/login"
        }
    }
    
    var method:Moya.Method{
        return .post
    }
    
    public var task:Task{
        switch self {
        case .login(let usr, let pwd):
            var params:[String:Any] = [:]
            params["username"] = usr//"18500206220"
            params["password"] = pwd//"Assassin1"
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    public var validate:Bool{
        return false
    }
    
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var headers:[String:String]?{
        return nil
    }
}

// MARK: - 设置请求头部信息
let endpointClosure = { (target: NetworkManager) -> Endpoint<NetworkManager> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint = Endpoint<NetworkManager>(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    
    return endpoint.adding(newHTTPHeaderFields: [
        "Content-Type" : "application/json",
        "ECP-COOKIE" : ""])
    
}
