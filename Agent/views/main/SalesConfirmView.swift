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

class SalesConfirmView: UIViewController {

    var buyer:[String:Any]?
    
    @IBOutlet weak var imgHeadIco: UIImageView!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var tfCount: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "售卡"
        // Do any additional setup after loading the view.
        lblNickName.text = buyer?["nick"] as! String
        lblUserId.text = String.init(format: "ID:%d", buyer?["id"] as! Int)
//        let icoURL = URL(string: (buyer?.header_img_src)!)
//        imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        let strURL = buyer?["header_img_src"] as! String
        if strURL == "" {
            imgHeadIco.image = UIImage(named: "headsmall")
        } else {
            let icoURL = URL(string: strURL)
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
        let type = buyer?["customerType"]
        requestSell(type: type as! String)
    }
    
    func requestSell(type:String){
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
        let id = buyer?["id"]
        let num = Int(tfCount.text!)
        if type == "A" {
            request(.sellcardToAgent(agentID: id as! Int, number: num!), success: handleSell)
//            Network.request(.sellcardToAgent(agentID: id!, number: num!), success: handleSell, provider: provider)
            
        }else
        {
            request(.sellcardToPlayer(playerID: id as! Int, number: num!), success: handleSell)
//            Network.request(.sellcardToPlayer(playerID: id!, number: num!), success: handleSell, provider: provider)
        }
    }
    
    func handleSell(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            dismiss(animated: true, completion: nil)
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
