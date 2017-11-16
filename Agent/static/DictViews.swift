//
//  DictViews.swift
//  Agent
//
//  Created by 于劲 on 2017/11/16.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation

class DictViews: NSObject{
    var views = Dictionary<String,Any>()
    override init() {
        views = [:]
        
        let mainBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainBoard.instantiateViewController(withIdentifier: "salesView") //as? SalesViewController
        views.updateValue(vc, forKey: "salesView")
    }
    
    func getView(v:String)->Any?{
        return views[v]
    }
}
