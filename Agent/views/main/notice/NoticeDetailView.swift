//
//  NoticeDetailView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/11.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeDetailView: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var webView: UIWebView!
    
    var noticeId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "公告详情"
        lblTitle = addLabel(title: "")
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byTruncatingTail
        lblTitle.frame.origin.y = 75
        lblTitle.frame.size.width = UIScreen.main.bounds.width - 20
        lblTitle.frame.size.height = 40
        lblTitle.font = UIFont.systemFont(ofSize: 16)
        lblTitle.textColor = UIColor.black
        
        lblTime = addLabel(title: "")
        lblTime.frame.origin.y = lblTitle.frame.origin.y + lblTitle.frame.height + 5
        lblTime.frame.size.width = UIScreen.main.bounds.width - 20
        lblTime.font = UIFont.systemFont(ofSize: 10)
        lblTime.textColor = UIColor(hex: "828282")
        
        request(.noticeDetail(noticeId: noticeId!), success: handleNotice)
        
        let y = lblTime.frame.origin.y + lblTime.frame.height + 20
        let rcWeb = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - y)
        webView = UIWebView.init(frame: rcWeb)
        view.addSubview(webView)
        
        webView.scrollView.bounces = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func handleNotice(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            let data = result["data"]
            lblTitle.text = data["title"].stringValue
            lblTime.text = data["createTime"].stringValue
            let content = data["content"].stringValue
            webView.loadHTMLString(content, baseURL: nil)
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
