//
//  agreement.swift
//  Agent
//
//  Created by 于劲 on 2017/12/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class agreement: UIViewController {

    var webView: UIWebView!
    var btnAffirm:UIButton!
    var needAffirm:Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "代理协议"
        webView = UIWebView.init(frame: CGRect(x:0,y:0,width:view.bounds.width,height:view.bounds.height))
        view.addSubview(webView)
        let path = Bundle.main.path(forResource: "agreement", ofType: "html")
        let pathURL = URL(fileURLWithPath: path!)
        webView.loadRequest(URLRequest(url: pathURL))
        
        if needAffirm {
            let rightButton = UIBarButtonItem(title: "同意", style: .plain, target: self, action: #selector(affirm(_:)))
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handAffirm(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            toastMSG(result: result)
            _ = navigationController?.popViewController(animated: true)
        }
    }

    func affirm(_ sender: Any) {
        request(.affirm, success: handAffirm)
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
