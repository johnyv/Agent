//
//  ImageEncoding.swift
//  Agent
//
//  Created by 于劲 on 2017/12/19.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Alamofire

class ImageEncoding: ParameterEncoding {
    static let `default` = ImageEncoding()
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let data = parameters else {
            return request
        }

        print(data)
        
        //let body = try JSONSerialization.data(withJSONObject: data, options: [])
        let body = try? NSKeyedArchiver.archivedData(withRootObject: data)
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = body
        
        return request
    }
}
