//
//  Common.swift
//  Agent
//
//  Created by 于劲 on 2017/11/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import SwiftyJSON

//func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
//    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
//                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
//                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
//                   alpha: 1.0)
//}
//
//func decodeJWT(tokenstr:String)->(String){
//    let arr = tokenstr.components(separatedBy: ".")
//    
//    var base64Str = arr[1] as String
//    if base64Str.characters.count % 4 != 0 {
//        let padlen = 4 - base64Str.characters.count % 4
//        base64Str += String(repeating: "=", count: padlen)
//    }
//    
//    if let data = Data(base64Encoded: base64Str, options: []),
//        let str = String(data: data, encoding: String.Encoding.utf8) {
//        return str
//    }
//    return ""
//}

func setAgent(data:JSON)->(){
    var agent:[String:Any] = [:]
    
    agent["account"] = data["account"].stringValue
    agent["agentId"] = data["agentId"].intValue
    agent["roleId"] = data["roleId"].intValue
    agent["name"] = data["name"].stringValue
    agent["nickName"] = data["nickName"].stringValue
    agent["gameName"] = data["gameName"].stringValue
    agent["serverCode"] = data["serverCode"].stringValue
    agent["headImg"] = data["headImg"].stringValue
    agent["lastBuyTime"] = data["lastBuyTime"].stringValue
    
    UserDefaults.standard.set(agent, forKey: "AGENT")
}

func setAuthority(agent:JSON) -> () {
    var authority = [String]()
    let authorityList = agent["authorityList"].array
    for(_, data) in (authorityList?.enumerated())!{
        authority.append(data.stringValue)
    }
    
    UserDefaults.standard.set(authority, forKey: "AUTHORITY")
}

func getAuthority() -> Array<String> {
    let authority = UserDefaults.standard.array(forKey: "AUTHORITY") as! [String]
    return authority
}

func getAgent() -> Dictionary<String, Any> {
    let agent = UserDefaults.standard.dictionary(forKey: "AGENT")! as [String:Any]
    return agent
}

func setProfile(data:JSON) -> () {
    let profile = getProfileFromJSON(data: data)
    UserDefaults.standard.set(profile, forKey: "PROFILE")
}

func getProfileFromJSON(data:JSON) -> Dictionary<String, Any>{
    var profile:[String:Any] = [:]
    
    profile["headerImgSrc"] = data["headerImgSrc"].stringValue
    profile["nickName"] = data["nickName"].stringValue
    profile["account"] = data["account"].stringValue
    profile["agentId"] = data["agentId"].stringValue
    profile["proofName"] = data["proofName"].stringValue
    profile["bindTel"] = data["bindTel"].stringValue
    profile["weChatLogin"] = data["weChatLogin"].boolValue
    profile["gameName"] = data["gameName"].stringValue
    profile["serverCity"] = data["serverCity"].stringValue
    profile["createTime"] = data["createTime"].stringValue
    profile["cardCount"] = data["cardCount"].intValue
    profile["agentType"] = data["agentType"].stringValue
    
    return profile
}

func getProfile() -> Dictionary<String, Any> {
    let profile = UserDefaults.standard.dictionary(forKey: "PROFILE")! as [String:Any]
    return profile
}

func getSavedToken()->(String){
    let token = UserDefaults.standard.string(forKey: "agentToken")
    if (token != nil){
        return token!
    }else{
        return ""
    }
}

func loadVCfromLogin(identifier:String)->(UIViewController){
    let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: identifier)
    return vc
}
func loadVCfromMain(identifier:String)->(UIViewController){
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    return vc
}

