//
//  ModifyPasswordView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/12.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class ModifyPasswordView: UIViewController {

    @IBOutlet weak var tfNewPwd: UITextField!
    @IBOutlet weak var tfReNewPwd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.title = "修改密码"
        let btnModify = addButton(title: "修改密码", action: #selector(self.doModify(_:)))
        let lblDesc = addLabel(title: "请为当前帐号重设6-16位密码，需含大、小写字母及数字")
        lblDesc.font = UIFont.systemFont(ofSize: 13)
        lblDesc.frame.origin.y = 15
        lblDesc.frame.size.width = UIScreen.main.bounds.width - lblDesc.frame.origin.x
        
        tfNewPwd = addTextField(placeholder: "请输入密码")
        tfNewPwd.isSecureTextEntry = true
        tfNewPwd.frame.origin.y = lblDesc.frame.origin.y + lblDesc.frame.height + 40
        alignUIView(v: tfNewPwd, position: .center)
        let line1 = addUnderLine(v: tfNewPwd)
        
        tfReNewPwd = addTextField(placeholder: "再次输入密码")
        tfReNewPwd.isSecureTextEntry = true
        tfReNewPwd.frame.origin.y = line1.frame.origin.y + 35
        alignUIView(v: tfReNewPwd, position: .center)
        let line2 = addUnderLine(v: tfReNewPwd)
        
        btnModify.frame.origin.y = line2.frame.origin.y + 60
        btnModify.setBorder(type: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleResult(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            dismiss(animated: true, completion: nil)
        } else if code == 11600 {
            toastMSG(result : result)
        } else {
            toastMSG(result : result)
//            alertResult(code: code)
        }
    }

    func doModify(_ sender: UIButton){
        let newPass = tfNewPwd.text
        let reNew = tfReNewPwd.text
        
        request(.pwdChange(pwd: newPass!, rpwd: reNew!), success: handleResult)
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
