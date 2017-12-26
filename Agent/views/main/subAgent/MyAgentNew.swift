//
//  MyAgentToOpen.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import HooDatePicker

class MyAgentNew: UIViewController {
    let sectionHeaders = ["姓名",
                          "游戏ID",
                          "手机号",
                          "验证码",
                          "所属游戏",
                          "类型",
                          "二级数量",
                          "有效期",
                          ]
    
    let placeHolders = ["请填写代理真实姓名",
                        "请填写玩家ID",
                        "输入开通代理手机号",
                        "输入验证码"]
    
//    @IBOutlet weak var tfUSerName: UITextField!
//    @IBOutlet weak var tfUserId: UITextField!
    var roleId:Int?
    var date:Date?
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfID: UITextField!
    var tfTel: MobilephoneField!
    var tfVerificationCode: UITextField!

    @IBOutlet weak var btnSms: SMSCountButton!
    @IBOutlet weak var btnVoice: SMSCountButton!

    var agentPermission = [[String:Any]]()
    var segType: UISegmentedControl!

    var lblSubCount:UILabel!
    var line7:UIView!
    var lblValidityPeriod:UILabel!
    var line8:UIView!
    @IBOutlet weak var tfSubCount: UITextField!
    @IBOutlet weak var lblPeriod: UILabel!
    
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

//    @IBOutlet weak var tfVipAgentOpenLimit: UITextField!
//    @IBOutlet weak var tfNormalAgentOpenLimit: UITextField!
//    @IBOutlet weak var tfSubAgentOpenLimit: UITextField!
//    @IBOutlet weak var tfValidityPeriod: UITextField!
    var pageDelegate:PageRefreshDelegate?
    
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
        title.font = UIFont.systemFont(ofSize: 14)
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
        
        let agent = AgentSession.shared.agentModel
        let gameName = agent?.gameName
        let lblGameName = addLabel(title: gameName!)
        lblGameName.frame.origin.y = lblGame.frame.origin.y
        lblGameName.textAlignment = .right
        alignUIView(v: lblGameName, position: .right)
        let line5 = addUnderLine(v: lblGame)
        
        let lblType = addLabel(title: sectionHeaders[5])
        lblType.frame.origin.y = line5.frame.origin.y + line5.frame.height + 10
        let items = ["县市普通代理", "二级代理", "VIP代理"]
        segType = UISegmentedControl()//UISegmentedControl(items: items)
        segType.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        //segType.setContentOffset(CGSize(width: 100, height: 25), forSegmentAt: 0)
        //segType.setWidth(100, forSegmentAt: 0)
        segType.frame.origin.y = lblType.frame.origin.y
        segType.isMomentary = false
        view.addSubview(segType)
        let line6 = addUnderLine(v: lblType)
        line6.frame.origin.y += 5
        
        // Vip项
        lblSubCount = addLabel(title: sectionHeaders[6])
        lblSubCount.frame.origin.y = line6.frame.origin.y + line6.frame.height + 5
        tfSubCount = addTextField(placeholder: "请填写数量")
        tfSubCount.frame.origin.y = lblSubCount.frame.origin.y
        tfSubCount.textAlignment = .right
        alignUIView(v: tfSubCount, position: .right)
        line7 = addUnderLine(v: lblSubCount)
        
        lblValidityPeriod = addLabel(title: sectionHeaders[7])
        lblValidityPeriod.frame.origin.y = line7.frame.origin.y + line7.frame.height + 5
        lblPeriod = addLabel(title: "小于等于您当前有效期")
        lblPeriod.frame.origin.y = lblValidityPeriod.frame.origin.y
        lblPeriod.frame.size.width = 200
        lblPeriod.textAlignment = .right
        alignUIView(v: lblPeriod, position: .right)
        line8 = addUnderLine(v: lblValidityPeriod)
        let tapDate = UITapGestureRecognizer(target: self, action: #selector(selectDate(_:)))
        lblPeriod.isUserInteractionEnabled = true
        lblPeriod.addGestureRecognizer(tapDate)

        // ----
        
        btnNew = addButton(title: "立即开通", action: #selector(new(_:)))
        btnCancel = addButton(title: "取消", action: #selector(new(_:)))
        
        
        btnNew.frame.origin.y = line8.frame.origin.y + 25
        btnCancel.frame.origin.y = btnNew.frame.origin.y + btnNew.frame.height + 25

        alignUIView(v: btnNew, position: .center)
        btnNew.setBorder(type: 0)
        alignUIView(v: btnCancel, position: .center)
        btnCancel.setBorder(type: 1)
        
        date = Date()
        
        let roleId = AgentSession.shared.agentModel?.roleId
        request(.permission(roleId: roleId!), success: handlePermission)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectDate(_ recognizer:UITapGestureRecognizer){
        
        let datePicker = HooDatePicker(superView: self.view)
        datePicker?.delegate = self
        datePicker?.locale = Locale(identifier: "zh_CN")
        datePicker?.datePickerMode = HooDatePickerMode.date
        datePicker?.show()
    }

    func new(_ sender:UIButton) {
        switch sender {
        case btnNew:
            let timeInterVal = Int((date?.timeIntervalSince1970)!*1000)
            
            if tfName.text == "" {
                view.makeToast(placeHolders[0])
                return
            }
            
            if tfID.text == "" {
                view.makeToast(placeHolders[1])
                return
            }

            if tfTel.text == "" {
                view.makeToast(placeHolders[2])
                return
            }

            if tfVerificationCode.text == "" {
                view.makeToast(placeHolders[3])
                return
            }
            let tel = tfTel.text?.trim()
            print("roleId",roleId)
            request(.myagentNew(name: tfName.text!, userId: Int(tfID.text!)!, tel: tel!, roleId: roleId!, verificationCode: tfVerificationCode.text!, vipAgentOpenLimit: 0, normalAgentOpenLimit: 0, subAgentOpenLimit: 0, validityPeriod: String(timeInterVal)), success: handleResult)
        case btnCancel:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    func handleSMS(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
        }else{
            toastMSG(result: result)
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
    
    func type(_ segmented:UISegmentedControl){
        let idx = segmented.selectedSegmentIndex
        setRoleId(idx: idx)
        showVip(idx: idx)
    }
    
    func setRoleId(idx:Int){
        switch idx {
        case 0:
            roleId = 1006
        case 1:
            roleId = 1004
        case 2:
            roleId = 1003
        default:
            break
        }
    }
    
    func showVip(idx:Int){
        let roleId:Int = agentPermission[idx]["roleId"] as! Int
        switch roleId {
        case 1006, 1004:
            lblSubCount.isHidden = true
            line7.isHidden = true
            lblValidityPeriod.isHidden = true
            line8.isHidden = true
            tfSubCount.isHidden = true
            lblPeriod.isHidden = true
        case 1003:
            lblSubCount.isHidden = false
            line7.isHidden = false
            lblValidityPeriod.isHidden = false
            line8.isHidden = false
            tfSubCount.isHidden = false
            lblPeriod.isHidden = false
        default:
            break
        }
    }
    
    func handlePermission(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            let dataArr = result["data"].array
            for(_, data) in (dataArr?.enumerated())!{
                let dataStr = data.stringValue
                var data = [String:Any]()
                switch dataStr {
                case "create_normalagent":
                    data["title"] = "普通代理"
                    data["roleId"] = 1006
                    agentPermission.append(data)
                case "create_subagent":
                    data["title"] = "二级代理"
                    data["roleId"] = 1004
                    agentPermission.append(data)
                case "create_vipagent":
                    data["title"] = "VIP代理"
                    data["roleId"] = 1003
                    agentPermission.append(data)
                default:
                    break
                }
            }
            
            print(agentPermission)

            for(i, data) in agentPermission.enumerated(){
                segType.insertSegment(withTitle: data["title"] as? String, at: i, animated: false)
            }
            
            segType.selectedSegmentIndex = 0
            segType.addTarget(self, action: #selector(self.type(_:)), for: .valueChanged)
            let count = agentPermission.count
            segType.frame.size.width = 80 * CGFloat(count)
            alignUIView(v: segType, position: .right)

            showVip(idx: segType.selectedSegmentIndex)
            setRoleId(idx: segType.selectedSegmentIndex)
        }
    }

    func handleResult(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            view.makeToast("开通成功", duration: 2, position: .center)
            pageDelegate?.refresh()
            _ = navigationController?.popViewController(animated: true)
        } else {
            toastMSG(result: result)
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

extension MyAgentNew: HooDatePickerDelegate{
    func datePicker(_ dataPicker: HooDatePicker!, didSelectedDate date: Date!) {
        self.date = date
    }
}
