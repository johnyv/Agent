//
//  OrdersView.swift
//  Agent
//
//  Created by 于劲 on 2017/11/29.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import SVProgressHUD
//import PagingMenuController
//
//private struct OrdersPageOptions: PagingMenuControllerCustomizable {
//    
//    private let allView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersListView") as! OrdersListView
//    
//    private let unpayedView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersListView") as! OrdersListView
//
//    private let payedView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersListView") as! OrdersListView
//    
//    fileprivate var componentType: ComponentType {
//        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
//    }
//    
//    fileprivate var pagingControllers: [UIViewController] {
//        return [allView, unpayedView, payedView]
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
//            return .text(title: MenuItemText(text: "全部订单",
//                                             color:.lightGray, selectedColor:.orange,
//                                             font:UIFont.systemFont(ofSize:16)))
//        }
//    }
//    
//    fileprivate struct MenuItem2: MenuItemViewCustomizable {
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "待支付", selectedColor:.orange))
//        }
//    }
//    
//    fileprivate struct MenuItem3: MenuItemViewCustomizable {
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "已完成", selectedColor:.orange))
//        }
//    }
//}
//
class OrdersView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbOrderList: UITableView!
    @IBOutlet weak var segSort: UISegmentedControl!
    let cellTableIdentifier = "orderListCell"
    var orderListData = [OrderListCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let options = OrdersPageOptions()
//        let ordersListPageController = PagingMenuController(options: options)
//        ordersListPageController.view.frame.origin.y += 65
//        
//        addChildViewController(ordersListPageController)
//        view.addSubview(ordersListPageController.view)
//        segSort.center = self.view.center
        segSort.selectedSegmentIndex = 0
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
        
        tbOrderList.delegate = self
        tbOrderList.dataSource = self
        tbOrderList.register(OrderListCell.self, forCellReuseIdentifier: cellTableIdentifier)
        let xib = UINib(nibName: "OrderListCell", bundle: nil)
        tbOrderList.register(xib, forCellReuseIdentifier: cellTableIdentifier)
        tbOrderList.rowHeight = 65
        
        requestData(idx: segSort.selectedSegmentIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectDate(_ sender: UIBarButtonItem) {
        let datePickerAlert:UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        
        datePickerAlert.addAction(UIAlertAction(title: "确定", style: .default){
            (alertAction)->Void in
            print("date select: \(datePicker.date.description)")
//            let myDateButton=self.Datebutt as? DateButton
//            myDateButton?.thedate=datePicker.date
//            //强制刷新
//            myDateButton?.setNeedsDisplay()
        })
        datePickerAlert.addAction(UIAlertAction(title: "取消", style: .cancel,handler:nil))
        datePickerAlert.view.addSubview(datePicker)
        present(datePickerAlert, animated: true, completion: nil)
    }
    func segDidchange(_ segmented:UISegmentedControl){
        print(segmented.selectedSegmentIndex)

//        let type = String(segmented.selectedSegmentIndex + 1)
        requestData(idx: segmented.selectedSegmentIndex)
    }
    
    func requestData(idx:Int){
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])
        
        let type = String(idx + 1)
        Network.request(.orderlist(year: "2017", month: "12", page: "1", type: type), success: handleData, provider: provider)
    }

    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            orderListData.removeAll()
            let data = result["data"]
            let dataArr = data["datas"].array
            for(_, element) in (dataArr?.enumerated())!{
                orderListData.append(OrderListCellModel(id: element["id"].stringValue,
                                                        orderNo: element["orderNo"].stringValue,
                                                        createTime: element["createTime"].stringValue,
                                                        cardNum: element["cardNum"].stringValue,
                                                        amount: element["amount"].stringValue,
                                                        payWay: element["payWay"].stringValue,
                                                        gameName: element["gameName"].stringValue,
                                                        orderStatus: element["orderStatus"].stringValue))
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tbOrderList.reloadData()
            })
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! OrderListCell
        let cellData = orderListData[indexPath.row]
        cell.lblCardName.text = cellData.gameName
        cell.lblOrderNo.text = cellData.orderNo
        cell.lblPrice.text = cellData.cardNum
        cell.lblStatus.text = cellData.orderStatus
        return cell
    }
    
    func requestOrder(orderNo:String){
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])
        
        Network.request(.cancel(orderNo: orderNo), success: handleOrder, provider: provider)
    }

    func handleOrder(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            SVProgressHUD.showInfo(withStatus: "取消成功")
            requestData(idx: segSort.selectedSegmentIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = orderListData[indexPath.row]
        let type = segSort.selectedSegmentIndex
        if type == 0 {
            let alertPay = UIAlertController(title: "确认", message: "取消"+cellData.orderNo!,
                                             preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                self.requestOrder(orderNo: cellData.orderNo!)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertPay.addAction(okAction)
            alertPay.addAction(cancelAction)
            self.present(alertPay, animated: true, completion: nil)
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
