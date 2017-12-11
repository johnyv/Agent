//
//  CardBuyListModel.swift
//  Agent
//
//  Created by 于劲 on 2017/12/6.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class CardBuyListModel: NSObject {
    var amount:String?
    //var date
    var time:String?
    var buyWay:String?
    var cardNum:Int?
    //var vipSend
    //var activitySend
    init(amount:String, time:String, buyWay:String, cardNum:Int){
        self.amount = amount
        self.time = time
        self.buyWay = buyWay
        self.cardNum = cardNum
    }
}
