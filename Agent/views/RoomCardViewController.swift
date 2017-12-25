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
import XLPagerTabStrip
//private struct RoomCardPageOptions: PagingMenuControllerCustomizable {
//    private let cardDepleteView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardDepleteView") as! CardDepleteView
//    private let cardBuyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardBuyView") as! CardBuyView
//    
//    fileprivate var componentType: ComponentType {
//        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
//    }
//    
//    fileprivate var pagingControllers: [UIViewController] {
//        return [cardDepleteView, cardBuyView]
//    }
//    
//    fileprivate struct MenuOptions: MenuViewCustomizable {
//        var displayMode: MenuDisplayMode {
//            return .segmentedControl
//        }
//        
//        var focusMode: MenuFocusMode{
//            return .underline(height: 2, color: .orange, horizontalPadding: 20, verticalPadding: 0)
//        }
//        var itemsOptions: [MenuItemViewCustomizable] {
//            return [MenuItem1(), MenuItem2()]
//        }
//    }
//    
//    fileprivate struct MenuItem1: MenuItemViewCustomizable {
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "房卡支出",
//                                             color:.lightGray, selectedColor:.orange,
//                                             font:UIFont.systemFont(ofSize:16)))
//        }
//    }
//    
//    fileprivate struct MenuItem2: MenuItemViewCustomizable {
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "购卡明细", selectedColor:.orange))
//        }
//    }
//}
class CardsDetailPageController: ButtonBarPagerTabStripViewController {
    
    var isReload = false
    
    override func viewDidLoad() {
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        settings.style.buttonBarItemTitleColor = UIColor.darkGray
        settings.style.buttonBarHeight = 35
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = .orange
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        super.viewDidLoad()

        let childView = viewControllers[currentIndex] as! RoomCardsDetail
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let page1 = RoomCardsDetail(style: .plain, pageInfo: "房卡支出")
        let page2 = RoomCardsDetail(style: .plain, pageInfo: "购卡明细")
        
        guard isReload else {
            return [page1, page2]
        }
        
        let childViews = [page1, page2]
        return childViews
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        
        let childView = viewControllers[currentIndex] as! RoomCardsDetail
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
}

class RoomCardViewController: UIViewController {

    @IBOutlet weak var lblSalesCount: UILabel!
    @IBOutlet weak var lblBuyCount: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var tbHeader1: UIView!
    @IBOutlet weak var tbHeader2: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vTopBg: UIView!
    
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var lblMonth:UILabel!
    
    let cellTableIdentifier = "roomCardDetailCell"
    var sourceData = [CardDetailCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vTopBg.backgroundColor = UIColor(hex: "008ce6")
////        let options = RoomCardPageOptions()
////        let roomCardPageController = PagingMenuController(options: options)
////        roomCardPageController.view.frame.origin.y += 200
////        
////        addChildViewController(roomCardPageController)
////        view.addSubview(roomCardPageController.view)
//        segSort.selectedSegmentIndex = 0
//        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        tableView.register(CustomerTableCell.self, forCellReuseIdentifier: cellTableIdentifier)
//        let xib = UINib(nibName: "RoomCardDetailCell", bundle: nil)
//        tableView.register(xib, forCellReuseIdentifier: cellTableIdentifier)
//        tableView.tableFooterView = UIView()
//        
//        tbHeader1.isHidden = true
//        tbHeader2.isHidden = true
        let rcBg = CGRect(x: 0, y: vTopBg.frame.origin.y + vTopBg.frame.height,
                          width: UIScreen.main.bounds.width, height: 25)
        let bg = UIView(frame: rcBg)
        bg.backgroundColor = UIColor(hex: "008cc6")
        view.addSubview(bg)
        let rcTitle = CGRect(x: 10, y: 0, width: bg.frame.width - 20, height: 30)
        lblMonth = UILabel(frame: rcTitle)
        bg.addSubview(lblMonth)
        lblMonth.text = "本月"
        lblMonth.font = UIFont.systemFont(ofSize: 14)
        
        let cardsViewPage = CardsDetailPageController()
        cardsViewPage.view.frame.origin.y = bg.frame.origin.y + bg.frame.height
        addChildViewController(cardsViewPage)
        view.addSubview(cardsViewPage.view)
        
        let idx:Int = segSort.selectedSegmentIndex
        let timeInterVal = Int(Date().timeIntervalSince1970*1000)

        request(.statisticAllNum(time: String(timeInterVal)), success: handleAllNum)
        requestBuyCount(time: String(timeInterVal))
        
        func handleInfo(json:JSON)->(){
            let result = json["result"]
            print(result)
            let code = result["code"].intValue
            if code == 200 {
                let data = result["data"]
                let cardCount:Int = data["cardCount"].intValue
                lblCurrent.text = String.init(format: "%d", cardCount)
            }
        }
        request(.myInfo, success: handleInfo)

        autoFit()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let idx:Int = segSort.selectedSegmentIndex
//        let timeInterVal = Int(Date().timeIntervalSince1970*1000)
//        print(timeInterVal)
////        requestAllNum(time: String(timeInterVal))
//        request(.statisticAllNum(time: String(timeInterVal)), success: handleAllNum)
//        requestBuyCount(time: String(timeInterVal))
//        
//        requestData(sort: idx)
//        showHaeder(idx: idx)
//        
//        func handleInfo(json:JSON)->(){
//            let result = json["result"]
//            print(result)
//            let code = result["code"].intValue
//            if code == 200 {
//                let data = result["data"]
//                let cardCount:Int = data["cardCount"].intValue
//                lblCurrent.text = String.init(format: "%d", cardCount)
//            }
//        }
//        request(.myInfo, success: handleInfo)
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let idx = segSort.selectedSegmentIndex
//        showHaeder(idx: idx)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func segDidchange(_ segmented:UISegmentedControl){
//        let sort = segmented.selectedSegmentIndex
//        requestData(sort: sort)
//        showHaeder(idx: sort)
//    }
//    
//    func showHaeder(idx:Int){
//        switch idx {
//        case 0:
//            tbHeader1.isHidden = false
//            tbHeader2.isHidden = true
//        case 1:
//            tbHeader1.isHidden = true
//            tbHeader2.isHidden = false
//        default: break
//            
//        }
//    }
    
//    func requestData(sort:Int){
////        let source = TokenSource()
////        source.token = getSavedToken()
////        let provider = MoyaProvider<NetworkManager>(plugins:[
////            AuthPlugin(tokenClosure: {return source.token})])
//        
//        let timeInterVal = Int(Date().timeIntervalSince1970*1000)
//        if sort == 0 {
//            request(.statisticList(time: String(timeInterVal), sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
////            Network.request(.statisticList(time: String(timeInterVal), sortType: 0, pageIndex: 0, pageNum: 0), success: handleData, provider: provider)
//        } else {
//            request(.goodDetail(time: String(timeInterVal), page: 1), success: handleData)
////            Network.request(.goodDetail(time: String(timeInterVal), page: 1), success: handleData, provider: provider)
//        }
//    }
//    
//    func handleData(json:JSON)->(){
//        let result = json["result"]
//        let code = result["code"].intValue
//        print(result)
//        if code == 200 {
//            sourceData.removeAll()
//            let data = result["data"]
//            let dataArr = data["datas"].array
//            let sort = segSort.selectedSegmentIndex
//            for(_, data) in (dataArr?.enumerated())!{
//                if sort == 0 {
//                    sourceData.append(CardDetailCellModel(col1: data["sellType"].stringValue, col2: data["cardNum"].stringValue, col3: data["id"].stringValue, col4: data["sellTime"].stringValue))
//                }else{
//                    sourceData.append(CardDetailCellModel(col1: data["buyWay"].stringValue, col2: data["cardNum"].stringValue, col3: data["amount"].stringValue, col4: data["time"].stringValue))
//                }
//            }
//            tableView.reloadData()
//            let count = sourceData.count
//            showNodata(dataCount: count)
//        }
//    }
//
//    func showNodata(dataCount:Int){
//        if dataCount > 0 {
//            imgNoData.isHidden = true
//            lblNoData.isHidden = true
//            tableView.isHidden = false
//        }else{
//            imgNoData.isHidden = false
//            lblNoData.isHidden = false
//            tableView.isHidden = true
//        }
//    }
    
    func requestBuyCount(time:String){
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
//        
//        Network.request(.goodDetailCollect(time: time), success: handleBuyCount, provider: provider)
        request(.goodDetailCollect(time: time), success: handleBuyCount)
    }
    
    func handleBuyCount(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let data = result["data"]
            lblBuyCount.text = data["goodCount"].stringValue
        }
    }

//    func requestAllNum(time:String){
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
//        
//        Network.request(.statisticAllNum(time: time), success: handleAllNum, provider: provider)
//    }
    
    func handleAllNum(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            lblSalesCount.text = result["data"].stringValue
        }
    }

    @IBAction func backToIndex(_ sender: UIBarButtonItem) {
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.menuTab?.selectedIndex = 0
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func service(_ sender: UIBarButtonItem) {
//        alertResult(code: 99)
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
