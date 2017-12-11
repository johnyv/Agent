//
//  ProfileInfoCell.swift
//  Agent
//
//  Created by 于劲 on 2017/11/30.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnOpt: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
