//
//  MyAgentListCell.swift
//  Agent
//
//  Created by 于劲 on 2017/12/19.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class MyAgentListCell: UITableViewCell {

    @IBOutlet weak var imgHeadIco: UIImageView!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var lblHoldCount: UILabel!
    @IBOutlet weak var lblLastTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
