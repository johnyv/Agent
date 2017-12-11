//
//  OrderListCellModel.swift
//  Agent
//
//  Created by 于劲 on 2017/12/5.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class OrderListCellModel: NSObject {
    var id:String?
    var orderNo:String?
    var createTime:String?
    var cardNum:Int?
    var amount:Float?
    var payWay:String?
    var gameName:String?
    var orderStatus:String?
    init( id:String,orderNo:String,createTime:String,cardNum:Int,amount:Float,payWay:String,gameName:String,orderStatus:String) {
        self.id = id
        self.orderNo = orderNo
        self.createTime = createTime
        self.cardNum = cardNum
        self.amount = amount
        self.payWay = payWay
        self.gameName = gameName
        self.orderStatus = orderStatus
    }
}
