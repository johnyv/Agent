//
//  MyAgentRecords.swift
//  Agent
//
//  Created by 于劲 on 2017/12/23.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class MyAgentRecords: UIViewController {

    @IBOutlet weak var lblTimes:UILabel!
    @IBOutlet weak var lblCount:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let imgHeadIco = addImageView()
        imgHeadIco.frame.origin.y = 5
        
        let agent = AgentSession.shared.agentModel
        
        let strURL = agent?.headImg
        let icoURL = URL(string: strURL!)
        imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        
        let lblNickName = addLabel(title: "")
        lblNickName.frame.origin.x = imgHeadIco.frame.origin.x + imgHeadIco.frame.width + 5
        lblNickName.frame.origin.y = imgHeadIco.frame.origin.y
        let nickName = agent?.nickName
        lblNickName.text = nickName
        
        let lblAgentID = addLabel(title: "")
        lblAgentID.frame.origin.x = imgHeadIco.frame.origin.x + imgHeadIco.frame.width + 5
        lblAgentID.frame.origin.y = lblNickName.frame.origin.y + lblNickName.frame.height
        
        let agentID = agent?.agentId
        lblAgentID.text = String.init(format: "ID:%d", agentID!)
        
        lblTimes = addLabel(title: "购卡次数")
        lblTimes.frame.origin.y = imgHeadIco.frame.origin.y + imgHeadIco.frame.height + 15
        let line1 = addUnderLine(v: lblTimes)
        lblCount = addLabel(title: "购卡张数")
        lblCount.frame.origin.y = line1.frame.origin.y + line1.frame.height + 5
        
        let y = lblCount.frame.origin.y + lblCount.frame.height + 5
        _ = addDivLine(y: y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
