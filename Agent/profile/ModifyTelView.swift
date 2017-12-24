//
//  ModifyTelView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/13.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class ModifyTelView: UIViewController {

    @IBOutlet weak var tfSmsOld: UITextField!
    @IBOutlet weak var btnSmsOld: SMSCountButton!
    @IBOutlet weak var btnVoiceOld: SMSCountButton!
    
    @IBOutlet weak var lblAreaCode: UILabel!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfSms: UITextField!
    @IBOutlet weak var btnSms: SMSCountButton!
    @IBOutlet weak var btnVoice: SMSCountButton!

    @IBOutlet weak var btnBind: UIButton!

    @IBOutlet weak var dpArea: ComboBox!
    let area = ["中国大陆", "台湾", "香港", "澳门"]
    let areaCode = ["86", "886", "852", "853"]

    var delegate:ModifyProfileDelegage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.title = "修改安全手机"
        
        let lblDesc = addLabel(title: "输入当前安全手机收到的验证码：")
        lblDesc.frame.origin.y = 5
        lblDesc.frame.size.width = 260
        tfSmsOld = addTextField(placeholder: "请输入验证码")
        tfSmsOld.frame.origin.y = lblDesc.frame.origin.y + lblDesc.frame.height + 25
        alignUIView(v: tfSmsOld, position: .center)
        _ = addUnderLine(v: tfSmsOld)
        
        btnSmsOld = addSmsButton(title: "获取验证码", action: #selector(sms(_:)))
        btnSmsOld.frame.origin.y = tfSmsOld.frame.origin.y
        btnSmsOld.frame.size.width = 80
        btnSmsOld.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        alignUIView(v: btnSmsOld, position: .right)
        
        btnVoiceOld = addSmsButton(title: "语音验证码", action: #selector(sms(_:)))
        btnVoiceOld.frame.origin.y = btnSmsOld.frame.origin.y + btnSmsOld.frame.height + 15
        btnVoiceOld.frame.size.width = 65
        btnVoiceOld.setTitleColor(UIColor(hex: "565656"), for: .normal)
        btnVoiceOld.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        alignUIView(v: btnVoiceOld, position: .right)
        
        let div = addDivLine(y: btnVoiceOld.frame.origin.y + btnVoiceOld.frame.height + 15)
        
        let lblArea = addLabel(title: "国家/地区")
        lblArea.frame.origin.y = div.frame.origin.y + div.frame.height + 35
        let line1 = addUnderLine(v: lblArea)
        
        lblAreaCode = addLabel(title: "+86")
        lblAreaCode.frame.origin.y = line1.frame.origin.y + line1.frame.height + 15
        let line2 = addUnderLine(v: lblAreaCode)
        
        let rcMobile = CGRect(x: 0, y: 0, width: 225, height: 25)
        tfMobile = MobilephoneField(frame: rcMobile)
        tfMobile.placeholder = "请输入手机号"
        tfMobile.frame.origin.y = lblAreaCode.frame.origin.y
        view.addSubview(tfMobile)
        alignUIView(v: tfMobile, position: .center)
        
        tfSms = addTextField(placeholder: "请输入验证码")
        tfSms.frame.origin.y = line2.frame.origin.y + line2.frame.height + 15
        alignUIView(v: tfSms, position: .center)
        _ = addUnderLine(v: tfSms)
        
        btnSms = addSmsButton(title: "获取验证码", action: #selector(smsNew(_:)))
        btnSms.frame.origin.y = tfSms.frame.origin.y
        btnSms.frame.size.width = 80
        btnSms.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        alignUIView(v: btnSms, position: .right)
        
        btnVoice = addSmsButton(title: "语音验证码", action: #selector(smsNew(_:)))
        btnVoice.frame.origin.y = btnSms.frame.origin.y + btnSms.frame.height + 15
        btnVoice.frame.size.width = 65
        btnVoice.setTitleColor(UIColor(hex: "565656"), for: .normal)
        btnVoice.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        alignUIView(v: btnVoice, position: .right)
        
        btnBind = addButton(title: "立即绑定", action: #selector(bind(_:)))
        btnBind.frame.origin.y = btnVoice.frame.origin.y + btnVoice.frame.height + 45
        alignUIView(v: btnBind, position: .center)
        btnBind.setBorder(type: 0)

        dpArea =  ComboBox(frame: CGRect(x: 0, y: lblArea.frame.origin.y, width: 160, height: 25))
        dpArea.delegate = self
        let count:CGFloat = CGFloat(area.count)
        dpArea.setComboBox(CGSize(width: 120, height: 44 * count))
        dpArea.setComboBoxData(area)
        view.addSubview(dpArea)
        dpArea.setComboBoxTitle(area[0])
        alignUIView(v: dpArea, position: .center)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func sms(_ sender:SMSCountButton){
        
        sender.isCounting = true

        switch sender {
        case btnSmsOld:
            request(.verificationCode(smsType: 2), success: handleSms)
        case btnVoiceOld:
            request(.verificationCode(smsType: 1), success: handleSms)
        default:
            break
        }
    }
    
    func smsNew(_ sender:SMSCountButton){
        
        let code = lblAreaCode.text?.replacingOccurrences(of: "+", with: "")
        if code != "86" {
            view.makeToast("暂不支持此区域")
            return
        }

        sender.isCounting = true

        switch sender {
        case btnSms:
            request(.bindSMS(tel: tfMobile.text!, smsType: 2), success: handleSms)
        case btnVoice:
            request(.bindSMS(tel: tfMobile.text!, smsType: 1), success: handleSms)
        default:
            break
        }
    }
    
    func bind(_ sender:UIButton){
        request(.bindTel(tel: tfMobile.text!, verificationCode: tfSms.text!), success: handleResult)
    }
    
    func handleResult(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            self.delegate?.refresh()
            dismiss(animated: true, completion: nil)
        }else{
            alertResult(code: code)
        }
    }

    func handleSms(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            self.delegate?.refresh()
            _ = navigationController?.popViewController(animated: true)
        }else{
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

extension ModifyTelView: ComBoxDelegate {
    func comboBox(_ comboBox: ComboBox!, didSelectRowAt indexPath: IndexPath!) {
        comboBox.setComboBoxTitle(area[indexPath.item])
        lblAreaCode.text = "+" + areaCode[indexPath.item]
    }
}
