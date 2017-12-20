//
//  MyAgentListTitle.swift
//  Agent
//
//  Created by 于劲 on 2017/12/19.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class MyAgentListTitle: UITableViewCell {

    @IBOutlet weak var lblAgentType: UILabel!
    @IBOutlet weak var lblAgentCard: UILabel!
    @IBOutlet weak var lblLastBuyTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
