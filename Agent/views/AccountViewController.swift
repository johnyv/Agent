//
//  AccountViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/10/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import Moya
class AccountViewController: UIViewController {

    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPwd: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSMSLogin: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 3

        btnSMSLogin.layer.borderWidth = 1
        btnSMSLogin.layer.borderColor = kRGBColorFromHex(rgbValue: 0x008ce6).cgColor
        btnSMSLogin.layer.cornerRadius = 3

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func accountLogin(_ sender: UIButton) {
//        let provider = MoyaProvider<NetworkManager>()
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
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
//                let authority = agent["authorityList"].array
//                print(authority[1])
//                UserDefaults.standard.set(authority, forKey: "authority")
//                AgentInfo.instance.account = agent["account"].stringValue
//                AgentInfo.instance.agentId = agent["agentId"].stringValue
//                AgentInfo.instance.roleId = agent["roleId"].stringValue
//                AgentInfo.instance.name = agent["name"].stringValue
//                AgentInfo.instance.nickName = agent["nickName"].stringValue
//                AgentInfo.instance.gameName = agent["gameName"].stringValue
//                AgentInfo.instance.serverCode = agent["serverCode"].stringValue
//                AgentInfo.instance.headImg = agent["headImg"].stringValue
//                AgentInfo.instance.lastBuyTime = agent["lastBuyTime"].stringValue
//                print(AgentInfo.instance.nickName)
                //                let authority = agent["authorityList"].array
                //                print(authority)
                //UserDefaults.standard.set(authority, forKey: "Array")
                appdelegate.login()
            }else{
                alertResult(code: code)
//                let alertController = UIAlertController(title: "系统提示",
//                                                        message: errMsg.desc(key: code), preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
//                    action in
//                })
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let usr = tfMobile.text
        let pwd = tfPwd.text
        let identifier = UIDevice.current.identifierForVendor
        request(.login(usr!, pwd!), success: handleLogin)
//        Network.request(.login(usr!, pwd!), success: handleLogin, provider: provider)
    }
    @IBAction func forgetPwd(_ sender: UIButton) {
        let forgotVC = loadVCfromLogin(identifier: "forgotViewController") as! ForgotViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
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
