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
    @IBOutlet weak var btnModify: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnModify.addTarget(self, action: #selector(self.doModify(_:)), for: .touchUpInside)
        
        autoFit()
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
            alertResult(code: code)
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
