//
//  MyAgentToOpen.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyAgentToOpen: UIViewController {

    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var vVip: UIView!
    @IBOutlet weak var btnNew: UIButton!
    
    @IBOutlet weak var tfUSerName: UITextField!
    @IBOutlet weak var tfTel: UITextField!
    @IBOutlet weak var tfUserId: UITextField!
    var roleId:Int?
    @IBOutlet weak var tfVerificationCode: UITextField!
    @IBOutlet weak var tfVipAgentOpenLimit: UITextField!
    @IBOutlet weak var tfNormalAgentOpenLimit: UITextField!
    @IBOutlet weak var tfSubAgentOpenLimit: UITextField!
    @IBOutlet weak var tfValidityPeriod: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let idx = 0
        segSort.selectedSegmentIndex = idx
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)

        btnNew.addTarget(self, action: #selector(self.doNew(_:)), for: .touchUpInside)
        
        let agent = getAgent()
        let gameName = agent["gameName"] as? String
        lblGameName.text = gameName
        
        showVip(idx: idx)
        setRoleId(idx: idx)
        autoFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func doNew(_ sender:UIButton) {
        let timeInterVal = Int(Date().timeIntervalSince1970*1000)

        request(.myagentNew(name: tfUSerName.text!, userId: Int(tfUserId.text!)!, tel: tfTel.text!, roleId: roleId!, verificationCode: tfVerificationCode.text!, vipAgentOpenLimit: 0, normalAgentOpenLimit: 0, subAgentOpenLimit: 0, validityPeriod: String(timeInterVal)), success: handleResult)
    }
    
    func handleSMS(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
        }
    }

    @IBAction func sms(_ sender:SMSCountButton) {
        sender.isCounting = true
        
        request(.agentSMS(tel: tfTel.text!, smsType: 2), success: handleSMS)
    }
    
    @IBAction func smsVoice(_ sender:SMSCountButton) {
        sender.isCounting = true
        
        request(.agentSMS(tel: tfTel.text!, smsType: 1), success: handleSMS)
    }

    func segDidchange(_ segmented:UISegmentedControl){
        let idx = segmented.selectedSegmentIndex
        showVip(idx: idx)
        setRoleId(idx: idx)
    }
    
    func setRoleId(idx:Int){
        switch idx {
        case 0:
            roleId = 1001
        case 1:
            roleId = 1004
        case 2:
            roleId = 1003
        default:
            break
        }
    }
    
    func showVip(idx:Int){
        if idx < 2 {
            vVip.isHidden = true
        }else{
            vVip.isHidden = false
        }
    }
    
    func handleResult(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            let data = result["data"]
//            let title = data["title"].stringValue
//            lblNotice.text = title
        }
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
