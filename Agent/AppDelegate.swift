//
//  AppDelegate.swift
//  Agent
//
//  Created by 于劲 on 2017/9/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Moya
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var menuTab: MenuViewController?
    var mainNavi: MainNaviController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.makeKeyAndVisible()

        IQKeyboardManager.sharedManager().enable = true
        
        let nav = UINavigationBar.appearance()
        nav.barTintColor = UIColor(hex: "008ce6")
        nav.tintColor = UIColor.white
        nav.backgroundColor = UIColor(hex: "008ce6")
        nav.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0),NSForegroundColorAttributeName: UIColor.white]
        nav.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.shadowImage = UIImage()
        
//        self.reLogin()
        
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
//
//        func handleResult(json:JSON)->(){
//            print(json)
//            let code = json["code"].intValue
//            if (code == 200){
//                let token = json["token"].stringValue
//                UserDefaults.standard.set(token, forKey: "agentToken")
//                let agent = json["agent"]
////                AgentInfo.instance.account = agent["account"].stringValue
////                AgentInfo.instance.agentId = agent["agentId"].stringValue
////                AgentInfo.instance.roleId = agent["roleId"].stringValue
////                AgentInfo.instance.name = agent["name"].stringValue
////                AgentInfo.instance.nickName = agent["nickName"].stringValue
////                let gameName:String = agent["gameName"].stringValue
////                AgentInfo.instance.gameName = agent["gameName"].stringValue
////                UserDefaults.standard.set(gameName, forKey: "gameName")
////                AgentInfo.instance.serverCode = agent["serverCode"].stringValue
////                AgentInfo.instance.headImg = agent["headImg"].stringValue
////                AgentInfo.instance.lastBuyTime = agent["lastBuyTime"].stringValue
////                //UserDefaults.standard.set(authority as! [String], forKey: "Array")
//                setAgent(data: agent)
//                let authority = agent["authorityList"]
//                setAuthority(agent:agent)
////                UserDefaults.standard.set(authority, forKey: "authority")
////                print(AgentInfo.instance.nickName)
//                
//                self.login()
//            }else{
//                self.reLogin()
//            }
//        }
//        Network.request(.refresh, success: handleResult, provider: provider)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "gatewaytest.xianlaigame.com" {
            let center = NotificationCenter.default
            center.post(name: NSNotification.Name(rawValue: "receiveWeixinSuccess"), object: nil)
        }
        return true
    }
        
    func reLogin() -> () {
 
        var topViewController:UIViewController?
        topViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        while ((topViewController?.presentedViewController) != nil) {
            topViewController = topViewController?.presentedViewController!
        }
        topViewController?.dismiss(animated: false, completion: nil)
        
        let rootVc = loadVCfromLogin(identifier: "loginMain") as? LoginViewController
        window?.rootViewController = rootVc
    }

    func enterApp() -> () {
        var topViewController:UIViewController?
        topViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        while ((topViewController?.presentedViewController) != nil) {
            topViewController = topViewController?.presentedViewController!
        }
        topViewController?.dismiss(animated: false, completion: nil)
        
        let rootVc = loadVCfromMain(identifier: "mainMenu") as? MenuViewController
        window?.rootViewController = rootVc
    }
}

