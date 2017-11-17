//
//  Common.swift
//  Agent
//
//  Created by 于劲 on 2017/11/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation

func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: 1.0)
}

let dictView = DictViews()

func decodeJWT(tokenstr:String)->(String){
    let arr = tokenstr.components(separatedBy: ".")
    
    var base64Str = arr[1] as String
    if base64Str.characters.count % 4 != 0 {
        let padlen = 4 - base64Str.characters.count % 4
        base64Str += String(repeating: "=", count: padlen)
    }
    
    if let data = Data(base64Encoded: base64Str, options: []),
        let str = String(data: data, encoding: String.Encoding.utf8) {
        //print(str)
        return str
    }
    return ""
}
