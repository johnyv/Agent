//
//  LoginViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/10/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Moya

class LoginViewController: UIViewController {
    @IBOutlet weak var tfMobile: MobilephoneField!
    @IBOutlet weak var tfSms: UITextField!

    @IBOutlet weak var btnSms: SMSCountButton!
    @IBOutlet weak var btnVoice: SMSCountButton!

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnWeixin: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblAreaCode: UILabel!
    
    @IBOutlet weak var dpArea: ComboBox!
    let area = ["中国大陆", "台湾", "香港", "澳门"]
    let areaCode = ["86", "886", "852", "853"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        imgLogo = addImageView()
        imgLogo.frame.size = CGSize(width: 115, height: 94)
        imgLogo.frame.origin.y = 60
        imgLogo.image = UIImage(named: "logo")
        alignUIView(v: imgLogo, position: .center)
        

//        dpArea.datasource = self
//        dpArea.delegate = self
//        dpArea.backgroundColor = .clear
//        dpArea.cellBgColor = .clear
//        dpArea.cellSelectionColor = .clear
        
        
        let lblArea = addLabel(title: "国家/地区")
        lblArea.frame.origin.y = imgLogo.frame.origin.y + imgLogo.frame.height + 80
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

        btnLogin = addButton(title: "登录", action: #selector(login(_:)))
        btnLogin.frame.origin.y = btnVoice.frame.origin.y + btnVoice.frame.height + 25
        alignUIView(v: btnLogin, position: .center)
        btnLogin.setBorder(type: 0)
        
        let line3 = addUnderLine(v: btnLogin)
        line3.frame.origin.y += 35
        let lblOther = addLabel(title: "其他方式登录")
        lblOther.backgroundColor = .white
        lblOther.frame.origin.y = line3.frame.origin.y - 13
        lblOther.frame.size.width = 80
        lblOther.textAlignment = .center
        lblOther.font = UIFont.systemFont(ofSize: 11)
        alignUIView(v: lblOther, position: .center)

        let center = UIScreen.main.bounds.width / 2
        btnWeixin = addButton(title: "微信登录", action: #selector(login(_:)))
        btnWeixin.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btnWeixin.frame.origin.x = center - btnWeixin.frame.width + 15
        btnWeixin.frame.origin.y =  lblOther.frame.origin.y + lblOther.frame.height + 10
        btnWeixin.setTitleColor(UIColor(hex: "565656"), for: .normal)
        btnWeixin.frame.size = CGSize(width: 65, height: 100)
        btnWeixin.backgroundColor = .clear
        btnWeixin.setImage(UIImage(named:"wx"), for: .normal)
        btnWeixin.setTitleAlign(position: .bottom)
        
        btnAccount = addButton(title: "密码登录", action: #selector(login(_:)))
        btnAccount.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btnAccount.frame.origin.x = center + btnAccount.frame.width / 2
        btnAccount.frame.origin.y =  btnWeixin.frame.origin.y
        btnAccount.setTitleColor(UIColor(hex: "565656"), for: .normal)
        btnAccount.frame.size = CGSize(width: 65, height: 100)
        btnAccount.backgroundColor = .clear
        btnAccount.setImage(UIImage(named:"pwd"), for: .normal)
        btnAccount.setTitleAlign(position: .bottom)
        
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
    
    func handleSMS(json:JSON)->(){
        let code = json["code"].intValue
        print(json)
        if code == 200 {
        }else{
            alertResult(code: code)
        }
    }

    func sms(_ sender: SMSCountButton) {
        sender.isCounting = true
        let mobileNo = tfMobile.text!
        let code = lblAreaCode.text?.replacingOccurrences(of: "+", with: "")
        if code != "86" {
            view.makeToast("暂不支持此区域")
            return
        }
        switch sender {
        case btnSms:
            request(.sms(phoneNo: mobileNo, areaCode: code!, msgType: 2), success: handleSMS)
        case btnVoice:
            request(.sms(phoneNo: mobileNo, areaCode: code!, msgType: 1), success: handleSMS)
        default:
            break
        }
    }
    
    func login(_ sender:UIButton){
        switch sender {
        case btnLogin:
            let usr = tfMobile.text
            let pwd = tfSms.text
            let identifier = UIDevice.current.identifierForVendor
            request(.login(usr!, pwd!), success: handleLogin)
            
        case btnAccount:
            let vc = AccountViewController()
            let navAccount = UINavigationController(rootViewController: vc)
            present(navAccount, animated: true, completion: nil)
            
        case btnWeixin:
            alertResult(code: 99)
        default:
            break
        }

    }
    
    func handleLogin(json:JSON)->(){
        let code = json["code"].intValue
        print(json)
        if code == 200 {
            let token = json["token"].stringValue
            UserDefaults.standard.set(token, forKey: "agentToken")
            
            let agent = json["agent"]
            setAgent(data: agent)
            setAuthority(agent: agent)

            let app = UIApplication.shared.delegate as! AppDelegate
            app.enterApp()
        }else{
            alertResult(code: code)
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

extension LoginViewController: ComBoxDelegate {
    func comboBox(_ comboBox: ComboBox!, didSelectRowAt indexPath: IndexPath!) {
        comboBox.setComboBoxTitle(area[indexPath.item])
        lblAreaCode.text = "+" + areaCode[indexPath.item]
    }
}
