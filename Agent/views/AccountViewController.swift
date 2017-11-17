//
//  AccountViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/10/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
//import JWT
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
        let usr = tfMobile.text
        let pwd = tfPwd.text
        NetProvider.request(.login(usr!, pwd!)){ result in
            if case let .success(response) = result{
                let data = try?response.mapJSON()
                let json = JSON(data!)
                let code = json["code"].intValue
                if code == 200{
                    let token = json["token"].stringValue
                    print(token)
                    let jsonStr = decodeJWT(tokenstr: token)
                    let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    let jsonToken = JSON(jsonData!)//try?JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as! JSON
                    print(jsonToken)
                    
                    let agentStr = jsonToken["agent"].stringValue
                    let agentData = agentStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    let agent = JSON(agentData!)//try?JSONSerialization.jsonObject(with: agentData!, options: .mutableContainers) as! JSON
                    
                    print(agent)
                    
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.login()
                }else{
                    let alertController = UIAlertController(title: "系统提示",
                                                            message: errMsg.desc(key: code), preferredStyle: .alert)
//                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                        action in
                        print("点击了确定")
                    })
//                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
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
