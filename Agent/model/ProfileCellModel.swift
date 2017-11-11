//
//  ProfileCellModel.swift
//  Agent
//
//  Created by 于劲 on 2017/11/2.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
enum CellCategory:Int{
    case section1 = 0, section2 = 1, section3 = 2, section4 = 3
}
class ProfileCellModel: NSObject {
    var title = ""
    var content = ""
    var category:CellCategory!
    init(title:String, content:String, category:CellCategory) {
        self.title = title
        self.content = content
        self.category = category
    }
}
