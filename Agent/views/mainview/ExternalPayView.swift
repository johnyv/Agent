//
//  ExternalPayView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/5.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import WebKit

class ExternalPayView: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var urlData:String?
//    var webView:WKWebView!
//    
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
//        webView.uiDelegate = self
//        view = webView
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(urlData)
        let str = UserDefaults.standard.string(forKey: "payURL")
        print(str)
        let urlStr = str?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: urlStr!)
        var request = URLRequest(url: url!)
        request.setValue("https://gatewaytest.xianlaigame.com", forHTTPHeaderField: "Referer")
        //request.httpMethod = "GET"
        view.addSubview(webView)
        webView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var webView : WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:0,
                                           width:UIScreen.main.bounds.size.width,
                                           height:UIScreen.main.bounds.size.height))
//        let url = URL(string: "http://www.baidu.com")
//        let requst = URLRequest(url: url!)
        web.uiDelegate = self
        web.navigationDelegate = self
//        web.load(requst)
        return web
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
