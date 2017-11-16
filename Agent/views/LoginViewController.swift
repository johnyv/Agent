//
//  LoginViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/10/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SVProgressHUD
class LoginViewController: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnVerifySMS: UIButton!
    @IBOutlet weak var tfSMS: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var btnSpeech: UIButton!

    @IBOutlet weak var btnWeixin: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnLogin.layer.cornerRadius = 3
        btnLogin.layer.masksToBounds = true
        btnVerifySMS.layer.cornerRadius = 3

        btnWeixin.setTitleAlign(position: .bottom)
        btnAccount.setTitleAlign(position: .bottom)
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startLogin(sender:UIButton){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.login()
        //SVProgressHUD.showInfo(withStatus: "loading...")
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainMenu") as! MenuViewController
//        self.present(vc, animated: true, completion: nil)
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
