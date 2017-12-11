//
//  DoPayView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import WebKit
class DoPayView: UIViewController, WKUIDelegate, WKNavigationDelegate{

//    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        webView.delegate = self
        
//        let str = UserDefaults.standard.string(forKey: "payURL")
//        print(str)
//        let urlStr = str?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let url = URL(string: urlStr!)
//        var request = URLRequest(url: url!)
//        //var request = NSMutableURLRequest(url: url!)
//        request.addValue("https://gatewaytest.xianlaigame.com ", forHTTPHeaderField: "Referer")
//        webView.loadRequest(request)
//        
//        print(urlData)
        let str = UserDefaults.standard.string(forKey: "payURL")
        print(str)
        let urlStr = str?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        var request = URLRequest(url: url!)
        //var request = NSMutableURLRequest(url: url!)
        //request.setValue("https://bp124361qg2c8gw.xianlaigame.com", forHTTPHeaderField: "Referer")
        //request.httpMethod = "GET"
        view.addSubview(webView)
//        webView.load(<#T##data: Data##Data#>, mimeType: <#T##String#>, characterEncodingName: <#T##String#>, baseURL: <#T##URL#>)
        webView.load(request)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var webView : WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:64,
                                           width:UIScreen.main.bounds.size.width,
                                           height:UIScreen.main.bounds.size.height))
        web.uiDelegate = self
        web.navigationDelegate = self
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
