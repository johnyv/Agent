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
    
    var nick:String = ""
    var headIco:String = ""
    var id:Int?
    var type:String?
    
    var imgHeadIco: UIImageView!
    var lblNickName: UILabel!
    var lblUserId: UILabel!
    var btnConfirm: UIButton!
    var tfCount: UITextField!
    
    var delegate:ConfirmDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "售卡"
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        imgHeadIco = addImageView()
        imgHeadIco.frame.origin.y = 25
        imgHeadIco.frame.size = CGSize(width: 100, height: 100)
        alignUIView(v: imgHeadIco, position: .center)
        
        lblNickName = addLabel(title: "")
        lblNickName.frame.origin.y = imgHeadIco.frame.origin.y + imgHeadIco.frame.height + 15
        alignUIView(v: lblNickName, position: .center)
        lblNickName.text = nick
        lblNickName.textAlignment = .center
        
        lblUserId = addLabel(title: "")
        lblUserId.frame.origin.y = lblNickName.frame.origin.y + lblNickName.frame.height + 5
        alignUIView(v: lblUserId, position: .center)
        lblUserId.text = String.init(format: "ID:%d", id!)
        lblUserId.textAlignment = .center
        
        tfCount = addTextField(placeholder: "售卡张数")
        tfCount.frame.origin.y = lblUserId.frame.origin.y + lblUserId.frame.height + 55
        alignUIView(v: tfCount, position: .center)
        let line1 = addUnderLine(v: tfCount)
        
        btnConfirm = addButton(title: "确认售卡", action: #selector(onConfirm(_:)))
        btnConfirm.frame.origin.y = line1.frame.origin.y + line1.frame.height + 55
        btnConfirm.setBorder(type: 0)
        
        let lblDesc = addLabel(title: "请确认玩家ID和数量无误，一旦确认支付将无法退卡")
        lblDesc.font = UIFont.systemFont(ofSize: 14)
        lblDesc.textAlignment = .center
        lblDesc.frame.origin.y = btnConfirm.frame.origin.y + btnConfirm.frame.height + 15
        lblDesc.frame.size.width = btnConfirm.frame.width
        alignUIView(v: lblDesc, position: .center)
        
        let strURL = headIco
        if strURL == "" {
            imgHeadIco.image = UIImage(named: "headsmall")
        } else {
            let icoURL = URL(string: strURL)
            imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        }
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
            _ = navigationController?.popViewController(animated: true)
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
