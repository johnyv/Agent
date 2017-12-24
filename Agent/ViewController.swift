//
//  ViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/9/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        launchAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        func handleResult(json:JSON)->(){
            print(json)
            let code = json["code"].intValue
            if (code == 200){
                //保存登录数据
                let token = json["token"].stringValue
                UserDefaults.standard.set(token, forKey: "agentToken")
                let agent = json["agent"]
                setAgent(data: agent)
                setAuthority(agent:agent)

                //进入主页
                let vc = loadVCfromMain(identifier: "mainMenu") as? MenuViewController
                delegate.window?.rootViewController = vc
                
            }else{
                //token失败，重新登录
                let vc = LoginViewController()
                delegate.window?.rootViewController = vc
            }
        }
        request(.refresh, success: handleResult)
    }
    
    //播放启动画面动画
    private func launchAnimation(){
        //获取启动视图
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil)
            .instantiateViewController(withIdentifier: "launch")
        let launchview = vc.view!
        let delegate = UIApplication.shared.delegate
        delegate?.window!!.addSubview(launchview)
        
        //播放动画效果，完毕后将其移除
        UIView.animate(withDuration: 1, delay: 1.5, options: .beginFromCurrentState,
                       animations: {
                        launchview.alpha = 0.0
                        let transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
                        launchview.layer.transform = transform
        }) { (finished) in
            launchview.removeFromSuperview()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UINavigationController{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
