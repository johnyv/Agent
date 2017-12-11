//
//  CardDetailCellModel.swift
//  Agent
//
//  Created by 于劲 on 2017/12/6.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class CardDetailCellModel: NSObject {
    var col1:String?
    var col2:String?
    var col3:String?
    var col4:String?
    init(col1:String, col2:String, col3:String, col4:String){
        self.col1 = col1
        self.col2 = col2
        self.col3 = col3
        self.col4 = col4
    }
}
