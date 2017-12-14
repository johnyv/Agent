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

//private struct CustomerPageOptions: PagingMenuControllerCustomizable {
////    private let tableRecentlyView = RecentlyView()
////    private let tableTotalView1 = TotalView1()
////    private let tableTotalView2 = TotalView2()
//    
//    private let tableRecentlyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableRecentlyView") as! TableRecentlyView
//    private let tableTotalView1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableTotalView1") as! TableTotalView1
//    private let tableTotalView2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableTotalView2") as! TableTotalView2
//
//    fileprivate var componentType: ComponentType {
//        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
//    }
//    
//    fileprivate var pagingControllers: [UIViewController] {
//        return [tableRecentlyView, tableTotalView1, tableTotalView2]
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
//            return [MenuItem1(), MenuItem2(), MenuItem3()]
//        }
//    }
//    
//    fileprivate struct MenuItem1: MenuItemViewCustomizable {
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "最近售卡",
//                                             color:.lightGray, selectedColor:.orange,
//                                             font:UIFont.systemFont(ofSize:16)))
//        }
//    }
//    
//    fileprivate struct MenuItem2: MenuItemViewCustomizable {
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "售卡次数", selectedColor:.orange))
//        }
//    }
//    
//    fileprivate struct MenuItem3: MenuItemViewCustomizable {
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "售卡张数", selectedColor:.orange))
//        }
//    }
//}

class CustomerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sellPerson: UILabel!
    @IBOutlet weak var sellCount: UILabel!
    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vTopBg: UIView!
    
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    let cellTableIdentifier = "customerTableCell"
    var sourceData = [CustomerTableCellModel]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vTopBg.backgroundColor = kRGBColorFromHex(rgbValue: 0x008ce6)
//        let options = CustomerPageOptions()
//        let customerPageController = PagingMenuController(options: options)
//        customerPageController.view.frame.origin.y += 200
//        addChildViewController(customerPageController)
//        view.addSubview(customerPageController.view)
//        customerPageController.didMove(toParentViewController: self)
        segSort.selectedSegmentIndex = 0
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomerTableCell.self, forCellReuseIdentifier: cellTableIdentifier)
        let xib = UINib(nibName: "CustomerTableCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: cellTableIdentifier)
        tableView.rowHeight = 65
        
        let radioW:CGFloat = UIScreen.main.bounds.width / 375.0
        let child = self.view.subviews
        for(_, data) in child.enumerated(){
            data.frame.origin.x *= radioW
            data.frame.origin.y *= radioW
            data.frame.size.width *= radioW
            data.frame.size.height *= radioW
        }


    }
    override func viewDidAppear(_ animated: Bool) {
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])

        //Network.request(.customerAllNum(searchId: 0, startDate: 0, endDate: 0), success: handleAllnum, provider: provider)
        request(.customerAllNum(searchId: 0, startDate: 0, endDate: 0), success: handleAllnum)
        requestData(sort: segSort.selectedSegmentIndex)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! CustomerTableCell
        
        // Configure the cell...
        let cellData = sourceData[indexPath.row]
        print(cellData.id)
        print(cellData.nick)
        //        cell.textLabel?.text = cellData.nick
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        let strURL = cellData.header_img_src
        if strURL == "" {
            cell.imgHeadIco.image = UIImage(named: "headsmall")
        } else {
            let icoURL = URL(string: strURL)
            cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        }
        cell.lblUserId.text = String.init(format: "ID:%d", cellData.id)
        cell.lblNickName.text = cellData.nick
        cell.lblCount.text = String.init(format: "%d张", cellData.cardNum)
        cell.lblTime.text = cellData.sellTime
        return cell
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.menuTab?.selectedIndex = 0
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func showDetail(_ sender: UIBarButtonItem) {
        let vc = loadVCfromMain(identifier: "soldToPlayerDetailView") as! SoldToPlayerDetailView
        present(vc, animated: true, completion: nil)
    }
    func segDidchange(_ segmented:UISegmentedControl){
        print(segmented.selectedSegmentIndex)
        requestData(sort: segmented.selectedSegmentIndex)
    }

    func requestData(sort:Int){
        var type:Int = 0
        
        switch sort {
        case 0:
            type = 0
        case 1:
            type = 2
        case 2:
            type = 3
        default:
            type = 0
        }
        request(.customerRecently(searchId: 0, startDate: 0, endDate: 0, sortType: type, pageIndex: 0, pageNum: 0), success: handleData)
    }
    
    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            sourceData.removeAll()
            let data = result["data"]
            let dataArr = data["datas"].array
            for(_, data) in (dataArr?.enumerated())!{
                sourceData.append(CustomerTableCellModel(id: data["id"].intValue, nick: data["nick"].stringValue, header_img_src: data["header_img_src"].stringValue, customerType: data["customerType"].stringValue, cardNum: data["cardNum"].intValue, sellTime: data["sellTime"].stringValue))
            }
            tableView.reloadData()
            let count = sourceData.count
            showNodata(dataCount: count)
        }
    }

    func showNodata(dataCount:Int){
        if dataCount > 0 {
            imgNoData.isHidden = true
            lblNoData.isHidden = true
            tableView.isHidden = false
        }else{
            imgNoData.isHidden = false
            lblNoData.isHidden = false
            tableView.isHidden = true
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
