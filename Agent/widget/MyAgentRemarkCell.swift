//
//  MyAgentRemarkCell.swift
//  Agent
//
//  Created by 于劲 on 2017/12/23.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class MyAgentRemarkCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfRemark: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
