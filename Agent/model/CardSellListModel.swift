//
//  CardSellListModel.swift
//  Agent
//
//  Created by 于劲 on 2017/12/6.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class CardSellListModel: NSObject {
    var sellType:String?
    var cardNum:Int?
    var id:String?
    var sellTime:String?
    init(sellType:String, cardNum:Int, id:String, sellTime:String){
        self.sellType = sellType
        self.cardNum = cardNum
        self.id = id
        self.sellTime = sellTime
    }
}
