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
    let sectionHeaders = ["姓名",
                          "ID",
                          "手机号",
                          "验证码",
                          "所属游戏",
                          "类型",
                          ]
    
    let placeHolders = ["请填写代理真实姓名",
                        "请填写代理ID",
                        "输入开通代理手机号",
                        "输入验证码"]

    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var vVip: UIView!
    
    
    @IBOutlet weak var tfUSerName: UITextField!
    @IBOutlet weak var tfUserId: UITextField!
    var roleId:Int?
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfID: UITextField!
    @IBOutlet weak var tfTel: MobilephoneField!
    @IBOutlet weak var tfVerificationCode: UITextField!

    @IBOutlet weak var btnSms: SMSCountButton!
    @IBOutlet weak var btnVoice: SMSCountButton!

    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    @IBOutlet weak var tfVipAgentOpenLimit: UITextField!
    @IBOutlet weak var tfNormalAgentOpenLimit: UITextField!
    @IBOutlet weak var tfSubAgentOpenLimit: UITextField!
    @IBOutlet weak var tfValidityPeriod: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        //addBackButtonToNavBar()
        self.title = "我的代理"
        let rcBg = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25)
        let bg = UIView(frame: rcBg)
        bg.backgroundColor = UIColor(hex: "cccccc")
        view.addSubview(bg)
        let rcTitle = CGRect(x: 10, y: 0, width: bg.frame.width - 20, height: 25)
        let title = UILabel(frame: rcTitle)
        title.text = "请填写您要开通的代理的基本信息"
        bg.addSubview(title)
        
        let lblName = addLabel(title: sectionHeaders[0])
        lblName.frame.origin.y = bg.frame.origin.y + bg.frame.height + 15
        let line1 = addUnderLine(v: lblName)
        tfName = addTextField(placeholder: placeHolders[0])
        tfName.frame.origin.y = lblName.frame.origin.y
        tfName.textAlignment = .right
        alignUIView(v: tfName, position: .right)
        
        let lblID = addLabel(title: sectionHeaders[1])
        lblID.frame.origin.y = line1.frame.origin.y + line1.frame.height + 15
        let line2 = addUnderLine(v: lblID)
        tfID = addTextField(placeholder: placeHolders[1])
        tfID.frame.origin.y = lblID.frame.origin.y
        tfID.textAlignment = .right
        alignUIView(v: tfID, position: .right)
        
        let lblMobile = addLabel(title: sectionHeaders[2])
        lblMobile.frame.origin.y = line2.frame.origin.y + line2.frame.height + 15
        let line3 = addUnderLine(v: lblMobile)
        tfTel = MobilephoneField(frame: CGRect(x: 0, y: lblMobile.frame.origin.y, width: 155, height: 25))
        view.addSubview(tfTel)
        tfTel.placeholder = placeHolders[2]
        tfTel.textAlignment = .right
        alignUIView(v: tfTel, position: .right)
        
        let lblSms = addLabel(title: sectionHeaders[3])
        lblSms.frame.origin.y = line3.frame.origin.y + line3.frame.height + 15
        tfVerificationCode = addTextField(placeholder: placeHolders[3])
        tfVerificationCode.frame.origin.y = lblSms.frame.origin.y
        alignUIView(v: tfVerificationCode, position: .center)
        
        btnSms = addSmsButton(title: "获取验证码", action: #selector(sms(_:)))
        btnSms.frame.origin.y = lblSms.frame.origin.y
        btnSms.frame.size.width = 80
        btnSms.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        alignUIView(v: btnSms, position: .right)
        
        btnVoice = addSmsButton(title: "语音验证", action: #selector(sms(_:)))
        btnVoice.frame.origin.y = btnSms.frame.origin.y + btnSms.frame.height + 15
        btnVoice.frame.size.width = 55
        btnVoice.setTitleColor(UIColor(hex: "565656"), for: .normal)
        btnVoice.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        alignUIView(v: btnVoice, position: .right)
        
        let div = addDivLine(y: lblSms.frame.origin.y + lblSms.frame.height + 50)
        let lblGame = addLabel(title: sectionHeaders[4])
        lblGame.frame.origin.y = div.frame.origin.y + div.frame.height + 5
        let line5 = addUnderLine(v: lblGame)
        
        let lblType = addLabel(title: sectionHeaders[5])
        lblType.frame.origin.y = line5.frame.origin.y + line5.frame.height + 5
        let line6 = addUnderLine(v: lblType)
        line6.frame.size.height = 2
        
        btnNew = addButton(title: "立即开通", action: #selector(new(_:)))
        btnCancel = addButton(title: "取消", action: #selector(new(_:)))
        btnCancel.frame.origin.y = UIScreen.main.bounds.height * 0.7
        alignUIView(v: btnCancel, position: .center)
        btnCancel.setBorder(type: 1)
        
        btnNew.frame.origin.y = btnCancel.frame.origin.y - btnNew.frame.height - 25
        alignUIView(v: btnNew, position: .center)
        btnNew.setBorder(type: 0)
//        segSort.selectedSegmentIndex = idx
//        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
//
//        btnNew.addTarget(self, action: #selector(self.doNew(_:)), for: .touchUpInside)
//        
//        let agent = getAgent()
//        let gameName = agent["gameName"] as? String
//        lblGameName.text = gameName
        
//        showVip(idx: idx)
//        setRoleId(idx: idx)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func new(_ sender:UIButton) {
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

    func sms(_ sender:SMSCountButton) {
        sender.isCounting = true
        switch sender {
        case btnSms:
            request(.agentSMS(tel: tfTel.text!, smsType: 2), success: handleSMS)
        case btnVoice:
            request(.agentSMS(tel: tfTel.text!, smsType: 1), success: handleSMS)
        default:
            break
        }
    }
    
//    func segDidchange(_ segmented:UISegmentedControl){
//        let idx = segmented.selectedSegmentIndex
////        showVip(idx: idx)
//        setRoleId(idx: idx)
//    }
//    
//    func setRoleId(idx:Int){
//        switch idx {
//        case 0:
//            roleId = 1001
//        case 1:
//            roleId = 1004
//        case 2:
//            roleId = 1003
//        default:
//            break
//        }
//    }
    
//    func showVip(idx:Int){
//        if idx < 2 {
//            vVip.isHidden = true
//        }else{
//            vVip.isHidden = false
//        }
//    }
    
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
