//
//  Common.swift
//  Agent
//
//  Created by 于劲 on 2017/11/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import SwiftyJSON

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

func getZeroTime(date:Date) ->(Date) {
    let calender = Calendar(identifier: .gregorian)
    var comps:DateComponents = DateComponents()
    comps = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    comps.hour = 0
    comps.minute = 0
    comps.second = 0
    let zeroTime:Date = calender.date(from: comps)!
    return zeroTime
}

let notifyRefrsh = NSNotification.Name(rawValue: "notifyRefrsh")
