//
//  NoticeListCellModel.swift
//  Agent
//
//  Created by 于劲 on 2017/12/11.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class NoticeListCellModel: NSObject {
    var id:Int?
    var title:String?
    var createTime:String?
    init(id:Int, title:String, createTime:String) {
        self.id = id
        self.title = title
        self.createTime = createTime
    }
}
