//
//  agreement.swift
//  Agent
//
//  Created by 于劲 on 2017/12/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class agreement: UIViewController {

    var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "代理协议"
        webView = UIWebView.init(frame: view.frame)
        view.addSubview(webView)
        let path = Bundle.main.path(forResource: "agreement", ofType: "html")
        let pathURL = URL(fileURLWithPath: path!)
        webView.loadRequest(URLRequest(url: pathURL))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
