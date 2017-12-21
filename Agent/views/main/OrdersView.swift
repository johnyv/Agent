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
import HooDatePicker
import PopupController
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
//    var orderListData = [OrderListCellModel]()
    var orderListData = [[String:Any]]()

    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var lblMonth: UILabel!
    var month:Int?
    
    var payDelegate:PayOrderDelegate?
    
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
        self.title = "我的购卡订单"
        segSort.selectedSegmentIndex = 0
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
        
        tbOrderList.delegate = self
        tbOrderList.dataSource = self
        tbOrderList.register(OrderListCell.self, forCellReuseIdentifier: cellTableIdentifier)
        let xib = UINib(nibName: "OrderListCell", bundle: nil)
        tbOrderList.register(xib, forCellReuseIdentifier: cellTableIdentifier)
        tbOrderList.rowHeight = 65
        
        btnSearch.addTarget(self, action: #selector(selectDate(_:)), for: .touchUpInside)
        requestData(idx: segSort.selectedSegmentIndex)
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps:DateComponents = DateComponents()
        let date = Date()
        comps = calendar.dateComponents([.year, .month], from: date)
        month = comps.month
//        lblMonth.text = String.init(format: "%d", month!)
        autoFit()
    }

    override func viewDidAppear(_ animated: Bool) {
        showNodata(dataCount: orderListData.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func selectDate(_ sender: UIButton){
        let datePicker = HooDatePicker(superView: self.view)
        datePicker?.delegate = self
        datePicker?.locale = Locale(identifier: "zh_CN")
        datePicker?.datePickerMode = HooDatePickerMode.yearAndMonth
        datePicker?.show()
    }

    func searchByData(_ sender: UIButton) {
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
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
        
        let type = String(idx + 1)
        request(.orderlist(year: "2017", month: "12", page: "1", type: type), success: handleData)
//        Network.request(.orderlist(year: "2017", month: "12", page: "1", type: type), success: handleData, provider: provider)
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
                var item:[String:Any] = [:]
                item["id"] = element["id"].stringValue
                item["orderNo"] = element["orderNo"].stringValue
                item["createTime"] = element["createTime"].stringValue
                item["cardNum"] = element["cardNum"].intValue
                item["amount"] = element["amount"].floatValue
                item["payWay"] = element["payWay"].stringValue
                item["gameName"] = element["gameName"].stringValue
                item["orderStatus"] = element["orderStatus"].stringValue
                orderListData.append(item)
                print(orderListData)
//                orderListData.append(OrderListCellModel(id: element["id"].stringValue,
//                                                        orderNo: element["orderNo"].stringValue,
//                                                        createTime: element["createTime"].stringValue,
//                                                        cardNum: element["cardNum"].intValue,
//                                                        amount: element["amount"].floatValue,
//                                                        payWay: element["payWay"].stringValue,
//                                                        gameName: element["gameName"].stringValue,
//                                                        orderStatus: element["orderStatus"].stringValue))
            }
//            DispatchQueue.main.async(execute: { () -> Void in
                tbOrderList.reloadData()
                showNodata(dataCount: orderListData.count)
//            })
        }
    }

    func showNodata(dataCount:Int){
        if dataCount > 0 {
            imgNoData.isHidden = true
            lblNoData.isHidden = true
            tbOrderList.isHidden = false
        }else{
            imgNoData.isHidden = false
            lblNoData.isHidden = false
            tbOrderList.isHidden = true
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
        let gameName = cellData["gameName"] as? String
        let num = cellData["cardNum"] as? Int
        cell.lblCardName.text = gameName! + String.init(format: "%d张", num!)
        
        cell.lblOrderNo.text = cellData["orderNo"] as? String
        let amount = cellData["amount"] as! Float
        cell.lblPrice.text = String.init(format: "%.2f元", amount)
        let status = cellData["orderStatus"] as? String
        if status == "UP" {
            cell.lblStatus.textColor = .orange
            cell.lblStatus.text = "待支付"
        } else {
            cell.lblStatus.textColor = .darkGray
            cell.lblStatus.text = "已完成"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = orderListData[indexPath.row]
        let type = segSort.selectedSegmentIndex
        if type == 0 {
            let payPopup = PopupController
            .create(self)
            .customize([.layout(.center)])
            
            let payContainer = PaymentOpt.instance()
            payContainer.closeHandler = { _ in
                payPopup.dismiss()
            }
            payContainer.cancelHandler = { result in
                payPopup.dismiss()
                print(result)
                let code = result["code"].intValue
                if code == 200 {
                    print(result)
                    self.view.makeToast("取消成功")
                    self.requestData(idx: self.segSort.selectedSegmentIndex)
                }
            }
            payContainer.payHandler = { result in
                print(result)
                let code = result["code"].intValue
                if code == 200 {
                    let dataStr = result["data"].stringValue
                    UserDefaults.standard.set(dataStr, forKey: "payURL")
                    let vc = DoPayView()
                    let naviVC = UINavigationController(rootViewController: vc)
                    self.present(naviVC, animated: true, completion: nil)
                } else {
                    self.toastMSG(result: result)
                }
            }
            
            _ = payPopup.show(payContainer)
            payDelegate = payContainer.self
            let orderNo = cellData["orderNo"] as? String
            payDelegate?.orderToPay(orderNo: orderNo!)
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

extension OrdersView : HooDatePickerDelegate{
    func datePicker(_ dataPicker: HooDatePicker!, didSelectedDate date: Date!) {
        print(date.description)
        
        let calender = Calendar(identifier: .gregorian)
        var comps:DateComponents = DateComponents()
        comps = calender.dateComponents([.year, .month], from: date)
        let year = comps.year
        let month = comps.month
        
        if self.month == month {
            lblMonth.text = "本月"
        } else {
            lblMonth.text = String.init(format: "%d月", month!)
        }
        
        let type = segSort.selectedSegmentIndex + 1
        request(.orderlist(year: String.init(format: "%d",year!), month: String.init(format: "%d",month!), page: "1", type: String(type)), success: handleData)
    }
}
