//
//  CustomerViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import PagingMenuController

private struct CustomerPageOptions: PagingMenuControllerCustomizable {
//    private let tableRecentlyView = RecentlyView()
//    private let tableTotalView1 = TotalView1()
//    private let tableTotalView2 = TotalView2()
    
    private let tableRecentlyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableRecentlyView") as! TableRecentlyView
    private let tableTotalView1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableTotalView1") as! TableTotalView1
    private let tableTotalView2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableTotalView2") as! TableTotalView2

    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [tableRecentlyView, tableTotalView1, tableTotalView2]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        
        var focusMode: MenuFocusMode{
            return .underline(height: 2, color: .orange, horizontalPadding: 20, verticalPadding: 0)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(), MenuItem3()]
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "最近售卡",
                                             color:.lightGray, selectedColor:.orange,
                                             font:UIFont.systemFont(ofSize:16)))
        }
    }
    
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "售卡次数", selectedColor:.orange))
        }
    }
    
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "售卡张数", selectedColor:.orange))
        }
    }
}

class CustomerViewController: UIViewController {
    
    @IBOutlet weak var sellPerson: UILabel!
    @IBOutlet weak var sellCount: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let options = CustomerPageOptions()
        let customerPageController = PagingMenuController(options: options)
        customerPageController.view.frame.origin.y += 200
        addChildViewController(customerPageController)
        view.addSubview(customerPageController.view)
        customerPageController.didMove(toParentViewController: self)
        
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])

        Network.request(.customerAllNum(searchId: 0, startDate: 0, endDate: 0), success: handleAllnum, provider: provider)
    }
    
    func didMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController){
        print("老页面：\(previousMenuController)")
        print("新页面：\(menuController)")
    }
    
    func handleAllnum(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let data = result["data"]
            sellPerson.text = data["sellPerson"].stringValue
            sellCount.text = data["sellCount"].stringValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.menuTab?.selectedIndex = 0
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
