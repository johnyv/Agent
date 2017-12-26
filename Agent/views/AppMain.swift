//
//  AppMain.swift
//  Agent
//
//  Created by 于劲 on 2017/12/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class AppMain: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let viewMain = loadVCfromMain(identifier: "main") as! MainViewController
        viewMain.title = "首页"
        let viewCustomer = loadVCfromMain(identifier: "customer") as! CustomerViewController
        viewCustomer.title = "客户"
        let viewRoomCard = loadVCfromMain(identifier: "roomCard") as! RoomCardViewController
        viewRoomCard.title = "房卡"
        let viewProfile = loadVCfromMain(identifier: "profile") as! ProfileViewController
        viewProfile.title = "我的"
        
        let main = UINavigationController(rootViewController: viewMain)
        main.tabBarItem.image = UIImage(named: "homepage_n")
        main.tabBarItem.selectedImage = UIImage(named: "homepage_s")
        
        let customer = UINavigationController(rootViewController: viewCustomer)
        customer.tabBarItem.image = UIImage(named: "customer_n")
        customer.tabBarItem.selectedImage = UIImage(named: "customer_s")

        let roomcard = UINavigationController(rootViewController: viewRoomCard)
        roomcard.tabBarItem.image = UIImage(named: "roomcards_n")
        roomcard.tabBarItem.selectedImage = UIImage(named: "roomcards_s")

        let profile = UINavigationController(rootViewController: viewProfile)
        profile.tabBarItem.image = UIImage(named: "profile_n")
        profile.tabBarItem.selectedImage = UIImage(named: "profile_s")

        self.viewControllers = [main, customer, roomcard, profile]
        self.selectedIndex = 0
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
