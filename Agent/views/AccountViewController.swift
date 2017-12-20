//
//  AccountViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/10/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
class AccountViewController: UIViewController {
    
    @IBOutlet weak var tfAccount:MobilephoneField!
    @IBOutlet weak var tfPassword:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "账号密码登录"
        let leftButton = UIBarButtonItem(image: UIImage(named: "ico_back"), style: .plain, target: self, action: #selector(switchBack(_:)))
        navigationItem.setLeftBarButton(leftButton, animated: true)

        let textWidth:CGFloat = 225
        let textCenter:CGFloat =  (UIScreen.main.bounds.width - textWidth) / 2
        let rcAccount = CGRect(x: textCenter, y: 160, width: textWidth, height: 25)
        tfAccount = MobilephoneField(frame: rcAccount)
        view.addSubview(tfAccount!)
        let line1 = addUnderLine(v: tfAccount!)
        
        tfPassword = addTextField(placeholder: "请输入密码")
        let rcPass = CGRect(x: textCenter, y: line1.frame.origin.y + line1.frame.height + 25, width: textWidth, height: 25)
        tfPassword.frame = rcPass
        tfPassword.isSecureTextEntry = true
        
        _ = addUnderLine(v: tfPassword!)
        
        let btnLogin = addButton(title: "登录", action: #selector(accountLogin(_:)))
        
        let buttonWidth:CGFloat = 325
        let buttonCenter:CGFloat = (UIScreen.main.bounds.width - buttonWidth) / 2
        
        btnLogin.frame = CGRect(x: buttonCenter, y: UIScreen.main.bounds.height / 2, width: buttonWidth, height: 41)
        btnLogin.setBorder(type: 0)
        
        let btnSwitchBack = addButton(title: "切换手机验证码登录", action: #selector(switchBack(_:)))
        btnSwitchBack.frame = CGRect(x: buttonCenter, y: btnLogin.frame.origin.y + btnLogin.frame.height + 30, width: buttonWidth, height: 41)
        btnSwitchBack.setBorder(type: 1)
        
        let btnLoss = addButton(title: "忘记密码？", action: #selector(loss(_:)))
        btnLoss.setTitleColor(UIColor(hex: "565656"), for: .normal)
        btnLoss.backgroundColor = .clear
        btnLoss.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btnLoss.frame = CGRect(x: btnSwitchBack.frame.origin.x + btnSwitchBack.frame.width - 70, y: btnSwitchBack.frame.origin.y+btnSwitchBack.frame.height+45, width: 70, height: 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func accountLogin(_ sender: UIButton) {
        let app = UIApplication.shared.delegate as! AppDelegate
        func handleLogin(json:JSON)->(){
            let code = json["code"].intValue
            print(json)
            if code == 0 {
                return
            }
            if code == 200 {
                let token = json["token"].stringValue
                UserDefaults.standard.set(token, forKey: "agentToken")
                let agent = json["agent"]
                setAgent(data: agent)
                setAuthority(agent: agent)
                
                app.enterApp()
            }else{
                alertResult(code: code)

            }
        }
        
        let usr = tfAccount.text?.replacingOccurrences(of: "-", with: "")
        let pwd = tfPassword.text
        let identifier = UIDevice.current.identifierForVendor
        request(.login(usr!, pwd!), success: handleLogin)
    }
    func loss(_ sender: UIButton) {
        alertResult(code: 99)
    }
    
    func switchBack(_ sender: Any) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let vcLogin = loadVCfromLogin(identifier: "loginMain") as? LoginViewController
        app.window?.rootViewController = vcLogin
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
