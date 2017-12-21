//
//  DataEncoding.swift
//  Agent
//
//  Created by 于劲 on 2017/11/24.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Alamofire

// gzlib压缩
class DataEncoding: ParameterEncoding {
    static let `default` = DataEncoding()
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        let requestBody = RequestBody(data: parameters!)

        let data:NSData = try JSONSerialization.data(withJSONObject: requestBody.body, options: []) as NSData
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        }
        
        for (key,value) in requestBody.body {
            
            if key == "body" {
                print("body------" + "\(value)")
            }
            if key == "header" {
                print("header----" + "\(value)")
            }
        }
        request.httpBody = data.gzipDeflate()
        
        return request
    }
}
