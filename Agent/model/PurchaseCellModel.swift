//
//  PurchaseCellModel.swift
//  Agent
//
//  Created by 于劲 on 2017/12/1.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class PurchaseCellModel: NSObject {
    var goodsId:String?
    var activityId:Int?
    var cardNum:String?
    var extraNum:Int?
    var activityExtraNum:Int?
    var price:String?
    var superscript:String?
    var desc:String?
    var createTime:String?
    
    init(goodsId:String,activityId:Int,cardNum:String,extraNum:Int,activityExtraNum:Int,price:String,superscript:String,desc:String,createTime:String) {
        self.goodsId = goodsId
        self.activityId = activityId
        self.cardNum = cardNum
        self.extraNum = extraNum
        self.activityExtraNum = activityExtraNum
        self.price = price
        self.superscript = superscript
        self.desc = desc
        self.createTime = createTime
    }
}
