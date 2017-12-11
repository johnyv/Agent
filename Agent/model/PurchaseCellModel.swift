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
    var cardNum:Int?
    var extraNum:Int?
    var activityExtraNum:Int?
    var price:Float?
    var superscript:String?
    var desc:String?
    var discount:Double?
    var discountFee:Double?
    var userGoodSuperscript:Int?
    var createTime:String?
    
    init(goodsId:String,activityId:Int,cardNum:Int,extraNum:Int,activityExtraNum:Int,price:Float,superscript:String,desc:String, discount:Double, discountFee:Double, userGoodSuperscript:Int, createTime:String) {
        self.goodsId = goodsId
        self.activityId = activityId
        self.cardNum = cardNum
        self.extraNum = extraNum
        self.activityExtraNum = activityExtraNum
        self.price = price
        self.superscript = superscript
        self.desc = desc
        self.discount = discount
        self.discountFee = discountFee
        self.userGoodSuperscript = userGoodSuperscript
        self.createTime = createTime
    }
}
