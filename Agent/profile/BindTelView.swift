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

    var delegateModify:ModifyProfileDelegage?
    
    @IBOutlet weak var tfTel: UITextField!
    @IBOutlet weak var tfSMS: UITextField!
    
    @IBOutlet weak var btnSMS: SMSCountButton!
    @IBOutlet weak var btnVoiceSMS: SMSCountButton!
    @IBOutlet weak var btnBind: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        btnSMS.addTarget(self, action: #selector(sms(_:)), for: .touchUpInside)
        btnVoiceSMS.addTarget(self, action: #selector(sms(_:)), for: .touchUpInside)
        btnBind.addTarget(self, action: #selector(bind(_:)), for: .touchUpInside)

    }
    
    func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sms(_ sender: SMSCountButton) {
        switch sender {
        case btnSMS:
            request(.bindSMS(tel: tfTel.text!, smsType: 2), success: handleSMS)
        case btnVoiceSMS:
            request(.bindSMS(tel: tfTel.text!, smsType: 1), success: handleSMS)
        default:
            break
        }
        sender.isCounting = true
    }

    func bind(_ sender:UIButton){
        request(.bindTel(tel: tfTel.text!, verificationCode: tfSMS.text!), success: handleResult)
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
        print(result)
        let code = result["code"].intValue
        if code == 200 {
//            let data = result["data"]
//            let title = data["title"].stringValue
//            lblNotice.text = title
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
