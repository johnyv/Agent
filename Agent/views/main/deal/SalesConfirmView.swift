//
//  SalesConfirmView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/5.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

protocol ConfirmDelegate {
    func confirmInfo(nick:String,
                     headIco:String,
                     id:Int,
                     type:String)
}

class SalesConfirmView: UIViewController {
    
    var nick:String?
    var headIco:String?
    var id:Int?
    var type:String?
    
    @IBOutlet weak var imgHeadIco: UIImageView!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var tfCount: UITextField!
    
    var delegate:ConfirmDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "售卡"
        // Do any additional setup after loading the view.
        lblNickName.text = nick
        lblUserId.text = String.init(format: "ID:%d", id!)
//        let icoURL = URL(string: (buyer?.header_img_src)!)
//        imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        let strURL = headIco
        if strURL == "" {
            imgHeadIco.image = UIImage(named: "headsmall")
        } else {
            let icoURL = URL(string: strURL!)
            imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        }

        btnConfirm.addTarget(self, action: #selector(onConfirm(_:)), for: .touchUpInside)
        
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func onConfirm(_ button:UIButton) {
        requestSell(type:type!)
    }
    
    func requestSell(type:String){
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
        if (tfCount.text?.isEmpty)! {
            showToast(string: "请输入张数")
            return;
        }
        let num = Int(tfCount.text!)
        if type == "A" {
            request(.sellcardToAgent(agentID: id!, number: num!), success: handleSell)
//            Network.request(.sellcardToAgent(agentID: id!, number: num!), success: handleSell, provider: provider)
            
        }else
        {
            request(.sellcardToPlayer(playerID: id!, number: num!), success: handleSell)
//            Network.request(.sellcardToPlayer(playerID: id!, number: num!), success: handleSell, provider: provider)
        }
    }
    
    func handleSell(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            showToast(string: "售卡成功")
            let center = NotificationCenter.default
            center.post(name: notifyRefrsh, object: nil)
            navigationController?.popViewController(animated: true)
        } else {
            toastMSG(result: result)
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

extension SalesConfirmView: ConfirmDelegate {
    func confirmInfo(nick: String, headIco: String, id: Int, type: String) {
        self.nick = nick
        self.headIco = headIco
        self.id = id
        self.type = type
    }
}
