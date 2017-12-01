//
//  OrdersView.swift
//  Agent
//
//  Created by 于劲 on 2017/11/29.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import PagingMenuController

private struct OrdersPageOptions: PagingMenuControllerCustomizable {
    
    private let allView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersListView") as! OrdersListView
    
    private let unpayedView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersListView") as! OrdersListView

    private let payedView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersListView") as! OrdersListView
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [allView, unpayedView, payedView]
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
            return .text(title: MenuItemText(text: "全部订单",
                                             color:.lightGray, selectedColor:.orange,
                                             font:UIFont.systemFont(ofSize:16)))
        }
    }
    
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待支付", selectedColor:.orange))
        }
    }
    
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已完成", selectedColor:.orange))
        }
    }
}

class OrdersView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let options = OrdersPageOptions()
        let ordersListPageController = PagingMenuController(options: options)
        ordersListPageController.view.frame.origin.y += 65
        
        addChildViewController(ordersListPageController)
        view.addSubview(ordersListPageController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
