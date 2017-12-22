//
//  ModifyNickView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/12.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class ModifyNickView: UIViewController {

    var delegateModify:ModifyProfileDelegage?
    
    @IBOutlet weak var tfNick: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        self.title = "修改昵称"
        let rightButton = UIBarButtonItem(title: "保存　", style: .plain, target: self, action: #selector(doModify(_:)))
        navigationItem.setRightBarButton(rightButton, animated: true)
        
        let lblNick = addLabel(title: "昵称：")
        lblNick.frame.origin.y = 5
        lblNick.frame.size.width = 45
        lblNick.font = UIFont.systemFont(ofSize: 14)
        
        tfNick = addTextField(placeholder: "请输入昵称")
        tfNick.frame.origin.x = lblNick.frame.origin.x + lblNick.frame.width
        tfNick.frame.origin.y = lblNick.frame.origin.y
        tfNick.frame.size.width = UIScreen.main.bounds.width - (lblNick.frame.width + 25)
        tfNick.textAlignment = .left
        tfNick.clearButtonMode = .whileEditing
        tfNick.font = UIFont.systemFont(ofSize: 15)
        
        _ = addUnderLine(v: tfNick)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doModify(_ sender: Any) {
        request(.editNick(nickName: tfNick.text!), success: handleResult)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
