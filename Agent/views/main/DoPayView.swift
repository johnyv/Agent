//
//  DoPayView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import WebKit
import Toast_Swift

class DoPayView: UIViewController, WKUIDelegate, WKNavigationDelegate{

//    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        var token: NSObjectProtocol?
        token = center.addObserver(forName: NSNotification.Name(rawValue: "receiveWeixinSuccess"), object: nil, queue: mainQueue) { (note) in
            print("receiveWeixinSuccess!")
            self.dismiss(animated: true, completion: nil)
            center.removeObserver(token!)
            self.view.makeToast("支付成功", duration: 2, position: .center)
        }
        
        let str = UserDefaults.standard.string(forKey: "payURL")
        
        let urlStr = str?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        view.addSubview(webView)
        
        request.setValue("gatewaytest.xianlaigame.com://", forHTTPHeaderField: "Referer")
        webView.load(request)
        
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let requestURL = navigationAction.request.url
        if requestURL?.scheme == "weixin" {
            decisionHandler(.cancel)
            UIApplication.shared.openURL(requestURL!)
        } else {
            decisionHandler(.allow)
        }
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
