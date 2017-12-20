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
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfSMS: UITextField!
    @IBOutlet weak var tfMobile: UITextField!

    @IBOutlet weak var btnWeixin: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var dividing1: UIView!
    @IBOutlet weak var dividing2: UIView!
    @IBOutlet weak var dividing3: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = self
//        imgLogo.snp.makeConstraints({(make) -> Void in
//            make.top.equalTo(60)
//            make.centerX.equalTo(self.view)})
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.masksToBounds = true
//        btnLogin.snp.makeConstraints({(make) -> Void in
//            make.top.equalTo(450)
//            make.width.equalTo(dividing1)
//            make.centerX.equalTo(self.view)})

        btnWeixin.setTitleAlign(position: .bottom)
        btnWeixin.addTarget(self, action: #selector(self.wxLogin(_:)), for: .touchUpInside)
        btnAccount.setTitleAlign(position: .bottom)
        
        autoFit()
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

    @IBAction func sms(_ sender: SMSCountButton) {
        sender.isCounting = true
        
        let mobileNo = tfMobile.text!
        
        request(.sms(phoneNo: mobileNo, areaCode: "86", msgType: 2), success: handleSMS)
//        Network.request(.login(usr!, pwd!), success: handleLogin, provider: provider)
    }
    
    @IBAction func smsVoice(_ sender: SMSCountButton) {
        sender.isCounting = true
        
        let mobileNo = tfMobile.text!
        
        request(.sms(phoneNo: mobileNo, areaCode: "86", msgType: 1), success: handleSMS)
    }
    @IBAction func startLogin(sender:UIButton){
//        let provider = MoyaProvider<NetworkManager>()

        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        func handleLogin(json:JSON)->(){
            let code = json["code"].intValue
            print(json)
            if code == 200 {
                let token = json["token"].stringValue
                UserDefaults.standard.set(token, forKey: "agentToken")
                let agent = json["agent"]
//                AgentInfo.instance.account = agent["account"].stringValue
//                AgentInfo.instance.agentId = agent["agentId"].stringValue
//                AgentInfo.instance.roleId = agent["roleId"].stringValue
//                AgentInfo.instance.name = agent["name"].stringValue
//                AgentInfo.instance.nickName = agent["nickName"].stringValue
//                AgentInfo.instance.gameName = agent["gameName"].stringValue
//                AgentInfo.instance.serverCode = agent["serverCode"].stringValue
//                AgentInfo.instance.headImg = agent["headImg"].stringValue
//                AgentInfo.instance.lastBuyTime = agent["lastBuyTime"].stringValue
                print(AgentInfo.instance.nickName)
//                let authority = agent["authorityList"].array
//                print(authority)
                //UserDefaults.standard.set(authority, forKey: "Array")
                appdelegate.enterApp()
            }else{
                alertResult(code: code)
//                let alertController = UIAlertController(title: "系统提示",
//                                                        message: errMsg.desc(key: code), preferredStyle: .alert)
//                //                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
//                    action in
//                    print("点击了确定")
//                })
//                //                    alertController.addAction(cancelAction)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let usr = tfMobile.text
        let pwd = tfSMS.text
        let identifier = UIDevice.current.identifierForVendor
        
        //Network.request(.login(usr!, pwd!), success: handleLogin, provider: provider)
        request(.login(usr!, pwd!), success: handleLogin)
        //SVProgressHUD.showInfo(withStatus: "loading...")
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainMenu") as! MenuViewController
//        self.present(vc, animated: true, completion: nil)
    }
    
//    func alertResult(code:Int, vc:ViewController) -> Void {
//        let alertController = UIAlertController(title: "系统提示",message: errMsg.desc(key: code), preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
//            action in
//        })
//        alertController.addAction(okAction)
//        vc.present(alertController, animated: true, completion: nil)
//    }
    
    func wxLogin(_ sender: UIButton) {
        alertResult(code: 99)
    }

    @IBAction func accountLogin(_ sender: UIButton) {
//        let vcAccount = loadVCfromLogin(identifier: "accountController") as! AccountController
        let vc = AccountViewController()
        let navAccount = UINavigationController(rootViewController: vc)
        present(navAccount, animated: true, completion: nil)
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window?.rootViewController = navAccount
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
