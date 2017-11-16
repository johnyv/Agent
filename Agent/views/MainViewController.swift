//
//  MainViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/10/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var btnClub: UIButton!
    @IBOutlet weak var vTopBG: UIView!
    @IBOutlet weak var navMain: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navMain.title = "首页"
        btnSale.setTitleAlign(position: .bottom)
        btnPurchase.setTitleAlign(position: .bottom)
        btnClub.setTitleAlign(position: .bottom)
        
        vTopBG.backgroundColor = kRGBColorFromHex(rgbValue: 0x008ce6)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pushSalesView(_ sender: UIButton) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.mainNavi?.pushSalesView()
//        navMain.title = "售卡"
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
