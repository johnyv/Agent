//
//  CustomerTableCell.swift
//  Agent
//
//  Created by 于劲 on 2017/11/29.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class CustomerTableCell: UITableViewCell {

    @IBOutlet weak var imgHeadIco: UIImageView!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
