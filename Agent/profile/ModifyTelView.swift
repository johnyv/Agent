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

    @IBOutlet weak var tfTelold: UITextField!
    @IBOutlet weak var btnSMSold: SMSCountButton!
    @IBOutlet weak var btnVoiceSMSold: SMSCountButton!
    
    @IBOutlet weak var tfTelnew: UITextField!
    @IBOutlet weak var tfSMS: UITextField!
    @IBOutlet weak var btnSMSnew: SMSCountButton!
    @IBOutlet weak var btnVoiceSMnew: SMSCountButton!

    @IBOutlet weak var btnBind: UIButton!

    var delegateModify:ModifyProfileDelegage?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改安全手机"
        // Do any additional setup after loading the view.
        btnSMSold.addTarget(self, action: #selector(sms(_:)), for: .touchUpInside)
        btnVoiceSMSold.addTarget(self, action: #selector(sms(_:)), for: .touchUpInside)
        btnSMSnew.addTarget(self, action: #selector(sms(_:)), for: .touchUpInside)
        btnVoiceSMnew.addTarget(self, action: #selector(sms(_:)), for: .touchUpInside)
        
        btnBind.addTarget(self, action: #selector(bind(_:)), for: .touchUpInside)

        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func sms(_ sender:SMSCountButton){
        switch sender {
        case btnSMSold:
            request(.verificationCode(smsType: 2), success: handleSMS)
        case btnVoiceSMSold:
            request(.verificationCode(smsType: 1), success: handleSMS)
        case btnSMSnew:
            request(.bindSMS(tel: tfTelnew.text!, smsType: 2), success: handleSMS)
        case btnVoiceSMnew:
            request(.bindSMS(tel: tfTelnew.text!, smsType: 1), success: handleSMS)
        default:
            break
        }
        sender.isCounting = true
    }
    
    func bind(_ sender:UIButton){
        request(.bindTel(tel: tfTelnew.text!, verificationCode: tfSMS.text!), success: handleResult)
    }
    
    func handleResult(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            self.delegateModify?.refresh()
            dismiss(animated: true, completion: nil)
        }else{
            alertResult(code: code)
        }
    }

    func handleSMS(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
//            self.delegateModify?.refresh()
//            dismiss(animated: true, completion: nil)
        }else{
//            alertResult(code: code)
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
