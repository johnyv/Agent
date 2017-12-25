//
//  BindTelView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/12.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class BindTelView: UIViewController {

    var delegate:ModifyProfileDelegage?
    
    @IBOutlet weak var lblAreaCode: UILabel!
    @IBOutlet weak var tfTel: UITextField!
    @IBOutlet weak var tfSms: UITextField!
    
    @IBOutlet weak var btnSms: SMSCountButton!
    @IBOutlet weak var btnVoice: SMSCountButton!
    @IBOutlet weak var btnBind: UIButton!
    
    @IBOutlet weak var dpArea: ComboBox!
    let area = ["中国大陆", "台湾", "香港", "澳门"]
    let areaCode = ["86", "886", "852", "853"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.title = "绑定安全手机"
        
        let lblArea = addLabel(title: "国家/地区")
        lblArea.frame.origin.y = 80//imgLogo.frame.origin.y + imgLogo.frame.height + 80
        let line1 = addUnderLine(v: lblArea)
        
        lblAreaCode = addLabel(title: "+86")
        lblAreaCode.frame.origin.y = line1.frame.origin.y + line1.frame.height + 15
        let line2 = addUnderLine(v: lblAreaCode)
        
        let rcMobile = CGRect(x: 0, y: 0, width: 225, height: 25)
        tfTel = MobilephoneField(frame: rcMobile)
        tfTel.placeholder = "请输入手机号"
        tfTel.frame.origin.y = lblAreaCode.frame.origin.y
        view.addSubview(tfTel)
        alignUIView(v: tfTel, position: .center)
        
        tfSms = addTextField(placeholder: "请输入验证码")
        tfSms.frame.origin.y = line2.frame.origin.y + line2.frame.height + 15
        alignUIView(v: tfSms, position: .center)
        _ = addUnderLine(v: tfSms)
        
        btnSms = addSmsButton(title: "获取验证码", action: #selector(sms(_:)))
        btnSms.frame.origin.y = tfSms.frame.origin.y
        btnSms.frame.size.width = 80
        btnSms.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        alignUIView(v: btnSms, position: .right)
        
        btnVoice = addSmsButton(title: "语音验证码", action: #selector(sms(_:)))
        btnVoice.frame.origin.y = btnSms.frame.origin.y + btnSms.frame.height + 15
        btnVoice.frame.size.width = 65
        btnVoice.setTitleColor(UIColor(hex: "565656"), for: .normal)
        btnVoice.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        alignUIView(v: btnVoice, position: .right)
        
        btnBind = addButton(title: "立即绑定", action: #selector(bind(_:)))
        btnBind.frame.origin.y = btnVoice.frame.origin.y + btnVoice.frame.height + 25
        alignUIView(v: btnBind, position: .center)
        btnBind.setBorder(type: 0)
        
        let lblDesc = addLabel(title: "绑定安全手机后，房卡异常变动和找回密码均可使用此手机号")
        lblDesc.numberOfLines = 0
        lblDesc.lineBreakMode = .byTruncatingTail
        lblDesc.frame.origin.y = btnBind.frame.origin.y + btnBind.frame.height + 55
        lblDesc.frame.size.width = UIScreen.main.bounds.width - 30
        lblDesc.frame.size.height = 40
        lblDesc.font = UIFont.systemFont(ofSize: 14)
        lblDesc.textColor = UIColor(hex: "565656")

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
    }
    
    @IBAction func sms(_ sender: SMSCountButton) {

        let code = lblAreaCode.text?.replacingOccurrences(of: "+", with: "")
        if code != "86" {
            view.makeToast("暂不支持此区域")
            return
        }
        switch sender {
        case btnSms:
            request(.bindSMS(tel: tfTel.text!, smsType: 2), success: handleSMS)
        case btnVoice:
            request(.bindSMS(tel: tfTel.text!, smsType: 1), success: handleSMS)
        default:
            break
        }
        sender.isCounting = true
    }

    func bind(_ sender:UIButton){
        request(.bindTel(tel: tfTel.text!, verificationCode: tfSms.text!), success: handleResult)
    }
    
    func handleResult(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            self.delegate?.refresh()
            _ = navigationController?.popViewController(animated: true)
        }else{
            alertResult(code: code)
        }
    }

    func handleSMS(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
//            delegate?.refresh()
//            _ = navigationController?.popViewController(animated: true)
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

extension BindTelView: ComBoxDelegate {
    func comboBox(_ comboBox: ComboBox!, didSelectRowAt indexPath: IndexPath!) {
        comboBox.setComboBoxTitle(area[indexPath.item])
        lblAreaCode.text = "+" + areaCode[indexPath.item]
    }
}
