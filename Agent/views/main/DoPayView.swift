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
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        //var request = NSMutableURLRequest(url: url!)
        //request.httpMethod = "GET"
        view.addSubview(webView)
//        webView.load(<#T##data: Data##Data#>, mimeType: <#T##String#>, characterEncodingName: <#T##String#>, baseURL: <#T##URL#>)
        
        
        
        request.setValue("https://gatewaytest.xianlaigame.com", forHTTPHeaderField: "Referer")
        webView.load(request)
        //webView.reload()
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //self.webView(webview, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        
        let requestURL = navigationAction.request
        print(requestURL.allHTTPHeaderFields)
//        switch navigationAction.navigationType {
//        case .linkActivated:
//            code
//        default:
//            <#code#>
//        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if !(navigationAction.targetFrame?.isMainFrame)! {
            webView.load(navigationAction.request)
        }
        return webView
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("跳转失败-->",error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("加载内容失败-->",error)
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var webView : WKWebView = {
        let cfg = WKWebViewConfiguration()
        cfg.preferences = WKPreferences()
        cfg.preferences.javaScriptEnabled = true
        cfg.preferences.javaScriptCanOpenWindowsAutomatically = true
        let web = WKWebView( frame: CGRect(x:0, y:64,
                                           width:UIScreen.main.bounds.size.width,
                                           height:UIScreen.main.bounds.size.height), configuration: cfg)
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
