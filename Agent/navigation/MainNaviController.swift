//
//  MainNaviController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/15.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class MainNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //appdelegate.window?.rootViewController = self
        appdelegate.mainNavi = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.title = "首页"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushSalesView() -> () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "salesView") as? SalesView
        self.pushViewController(vc!, animated: true)
//        self.title = "售卡"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
