//
//  RoomCardViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import PagingMenuController

private struct RoomCardPageOptions: PagingMenuControllerCustomizable {
    private let cardDepleteView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardDepleteView") as! CardDepleteView
    private let cardBuyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardBuyView") as! CardBuyView
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [cardDepleteView, cardBuyView]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        
        var focusMode: MenuFocusMode{
            return .underline(height: 2, color: .orange, horizontalPadding: 20, verticalPadding: 0)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "房卡支出",
                                             color:.lightGray, selectedColor:.orange,
                                             font:UIFont.systemFont(ofSize:16)))
        }
    }
    
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "购卡明细", selectedColor:.orange))
        }
    }
}

class RoomCardViewController: UIViewController {

    @IBOutlet weak var lblSalesCount: UILabel!
    @IBOutlet weak var lblBuyCount: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let options = RoomCardPageOptions()
        let roomCardPageController = PagingMenuController(options: options)
        roomCardPageController.view.frame.origin.y += 200
        
        addChildViewController(roomCardPageController)
        view.addSubview(roomCardPageController.view)
        requestAllNum(time: "")
        requestBuyCount(time: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let netProvider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
//        
//        netProvider.request(.goodList){ result in
//            if case let .success(response) = result{
//                let data = try?response.mapJSON()
//                let json = JSON(data!)
//                print(json)
//                let code = json["code"].intValue
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestBuyCount(time:String){
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])
        
        Network.request(.goodDetailCollect(time: time), success: handleBuyCount, provider: provider)
    }
    
    func handleBuyCount(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let data = result["data"]
            lblBuyCount.text = data["buyCount"].stringValue
        }
    }

    func requestAllNum(time:String){
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])
        
        Network.request(.statisticAllNum(time: time), success: handleAllNum, provider: provider)
    }
    
    func handleAllNum(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            lblSalesCount.text = result["data"].stringValue
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
