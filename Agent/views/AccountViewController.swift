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

    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPwd: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSMSLogin: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btnLogin.layer.cornerRadius = 3

        btnSMSLogin.layer.borderWidth = 1
        btnSMSLogin.layer.borderColor = kRGBColorFromHex(rgbValue: 0x008ce6).cgColor
        btnSMSLogin.layer.cornerRadius = 3
        btnSMSLogin.addTarget(self, action: #selector(self.backToPrev(_:)), for: .touchUpInside)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(), name: Notification.Name.UITextFieldTextDidChange, object: tfMobile)
        tfMobile.keyboardType = .numberPad
        underLine(v: tfPwd)
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToPrev(_ sender: Any) {
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
                setAuthority(agent: agent)
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
        alertResult(code: 99)
//        let forgotVC = loadVCfromLogin(identifier: "forgotViewController") as! ForgotViewController
//        self.navigationController?.pushViewController(forgotVC, animated: true)
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
