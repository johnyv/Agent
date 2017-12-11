//
//  CustomerTableCellModel.swift
//  Agent
//
//  Created by 于劲 on 2017/11/29.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class CustomerTableCellModel: NSObject {
    var id:Int = 0
    var nick:String = ""
    var header_img_src:String = ""
    var customerType:String = ""
    var cardNum:Int = 0
    var sellTime:String = ""
    init(id:Int, nick:String, header_img_src:String, customerType:String, cardNum:Int, sellTime:String) {
        self.id = id
        self.nick = nick
        self.header_img_src = header_img_src
        self.customerType = customerType
        self.cardNum = cardNum
        self.sellTime = sellTime
    }
}
