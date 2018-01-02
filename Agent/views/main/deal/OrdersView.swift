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
import HooDatePicker
import PopupController
import XLPagerTabStrip

class OrdersPageController: ButtonBarPagerTabStripViewController {
    
    var isReload = false
    
    var year:String = ""
    var month:String = ""
    
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
        
        let childView = viewControllers[currentIndex] as! OrdersList
        childView.pageDelegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let page1 = OrdersList(style: .plain, pageInfo: "待支付")
        let page2 = OrdersList(style: .plain, pageInfo: "已完成")
        
        guard isReload else {
            return [page1, page2]
        }
        
        let childViews = [page1, page2]
        return childViews
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let childView = viewControllers[currentIndex] as! OrdersList
        childView.pageDelegate = childView.self
        if self.year != "" && self.month != "" {
            childView.reNewRange(type: currentIndex, year: self.year, month: self.month)
        } else {
            childView.reNew(type: currentIndex)
        }
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        let childView = viewControllers[currentIndex] as! OrdersList
        childView.pageDelegate = childView.self
        if self.year != "" && self.month != "" {
            childView.reNewRange(type: currentIndex, year: self.year, month: self.month)
        } else {
            childView.reNew(type: currentIndex)
        }
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
    
    public func setTimeRange(year:String, month:String){
        self.year = year
        self.month = month
    }
}

class OrdersView: UIViewController {

    let cellTableIdentifier = "orderListCell"
    var orderListData = [[String:Any]]()
    
    var lblMonth: UILabel!
    var lblSearch: UILabel!
    var month:Int?
    
    var payDelegate:PayOrderDelegate?
    
    var ordersViewPage:OrdersPageController?
    
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
//        segSort.selectedSegmentIndex = 0
//        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
//        
//        tbOrderList.delegate = self
//        tbOrderList.dataSource = self
//        tbOrderList.register(OrderListCell.self, forCellReuseIdentifier: cellTableIdentifier)
//        let xib = UINib(nibName: "OrderListCell", bundle: nil)
//        tbOrderList.register(xib, forCellReuseIdentifier: cellTableIdentifier)
//        tbOrderList.rowHeight = 65
//        
//        btnSearch.addTarget(self, action: #selector(selectDate(_:)), for: .touchUpInside)
//        requestData(idx: segSort.selectedSegmentIndex)
        ordersViewPage = OrdersPageController()
        
        let rcBg = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        let bg = UIView(frame: rcBg)
        bg.backgroundColor = UIColor(hex: "1898e8")
        view.addSubview(bg)
        let rcLable = CGRect(x: 10, y: 0, width: 150, height: 30)
        lblMonth = UILabel(frame: rcLable)
        lblMonth.textColor = .white
        bg.addSubview(lblMonth)
        lblMonth.text = "本月"
        lblMonth.font = UIFont.systemFont(ofSize: 14)
        
        lblSearch = UILabel(frame: rcLable)
        lblSearch.frame.origin.x = bg.frame.width - lblSearch.frame.width - 20
        lblSearch.textAlignment = .right
        lblSearch.textColor = .white
        bg.addSubview(lblSearch)
        lblSearch.text = "搜索"
        lblSearch.font = UIFont.systemFont(ofSize: 14)
        
        let tapDate = UITapGestureRecognizer(target: self, action: #selector(selDate(_:)))
        lblSearch.isUserInteractionEnabled = true
        lblSearch.addGestureRecognizer(tapDate)

        ordersViewPage?.view.frame.origin.y = bg.frame.origin.y + bg.frame.height
        addChildViewController(ordersViewPage!)
        view.addSubview((ordersViewPage?.view)!)

        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps:DateComponents = DateComponents()
        let date = Date()
        comps = calendar.dateComponents([.year, .month], from: date)
        month = comps.month
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selDate(_ sender: UIButton){
        let datePicker = HooDatePicker(superView: self.view)
        datePicker?.delegate = self
        datePicker?.locale = Locale(identifier: "zh_CN")

        datePicker?.setHighlight(UIColor(hex: "1898e8"))
        
        let ft = DateFormatter()
        ft.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let minDate = ft.date(from: "01-01-2015 00:00:00")
        let maxDate = ft.date(from: "01-01-2025 00:00:00")
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate

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
//    func segDidchange(_ segmented:UISegmentedControl){
//        print(segmented.selectedSegmentIndex)
//
////        let type = String(segmented.selectedSegmentIndex + 1)
//        requestData(idx: segmented.selectedSegmentIndex)
//    }
//    
//    func requestData(idx:Int){
////        let source = TokenSource()
////        source.token = getSavedToken()
////        let provider = MoyaProvider<NetworkManager>(plugins:[
////            AuthPlugin(tokenClosure: {return source.token})])
//        
//        let type = String(idx + 1)
//        request(.orderlist(year: "2017", month: "12", page: "1", type: type), success: handleData)
////        Network.request(.orderlist(year: "2017", month: "12", page: "1", type: type), success: handleData, provider: provider)
//    }

//    func handleData(json:JSON)->(){
//        let result = json["result"]
//        let code = result["code"].intValue
//        if code == 200 {
//            print(result)
//            orderListData.removeAll()
//            let data = result["data"]
//            let dataArr = data["datas"].array
//            for(_, element) in (dataArr?.enumerated())!{
//                var item:[String:Any] = [:]
//                item["id"] = element["id"].stringValue
//                item["orderNo"] = element["orderNo"].stringValue
//                item["createTime"] = element["createTime"].stringValue
//                item["cardNum"] = element["cardNum"].intValue
//                item["amount"] = element["amount"].floatValue
//                item["payWay"] = element["payWay"].stringValue
//                item["gameName"] = element["gameName"].stringValue
//                item["orderStatus"] = element["orderStatus"].stringValue
//                orderListData.append(item)
//                print(orderListData)
////                orderListData.append(OrderListCellModel(id: element["id"].stringValue,
////                                                        orderNo: element["orderNo"].stringValue,
////                                                        createTime: element["createTime"].stringValue,
////                                                        cardNum: element["cardNum"].intValue,
////                                                        amount: element["amount"].floatValue,
////                                                        payWay: element["payWay"].stringValue,
////                                                        gameName: element["gameName"].stringValue,
////                                                        orderStatus: element["orderStatus"].stringValue))
//            }
////            DispatchQueue.main.async(execute: { () -> Void in
//                tbOrderList.reloadData()
//                showNodata(dataCount: orderListData.count)
////            })
//        }
//    }
//
//    func showNodata(dataCount:Int){
//        if dataCount > 0 {
//            imgNoData.isHidden = true
//            lblNoData.isHidden = true
//            tbOrderList.isHidden = false
//        }else{
//            imgNoData.isHidden = false
//            lblNoData.isHidden = false
//            tbOrderList.isHidden = true
//        }
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return orderListData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! OrderListCell
//        let cellData = orderListData[indexPath.row]
//        let gameName = cellData["gameName"] as? String
//        let num = cellData["cardNum"] as? Int
//        cell.lblCardName.text = gameName! + String.init(format: "%d张", num!)
//        
//        cell.lblOrderNo.text = cellData["orderNo"] as? String
//        let amount = cellData["amount"] as! Float
//        cell.lblPrice.text = String.init(format: "%.2f元", amount)
//        let status = cellData["orderStatus"] as? String
//        if status == "UP" {
//            cell.lblStatus.textColor = .orange
//            cell.lblStatus.text = "待支付"
//        } else {
//            cell.lblStatus.textColor = .darkGray
//            cell.lblStatus.text = "已完成"
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellData = orderListData[indexPath.row]
//        let type = segSort.selectedSegmentIndex
//        if type == 0 {
//            let payPopup = PopupController
//            .create(self)
//            .customize([.layout(.center)])
//            
//            let payContainer = PaymentOpt.instance()
//            payContainer.closeHandler = { _ in
//                payPopup.dismiss()
//            }
//            payContainer.cancelHandler = { result in
//                payPopup.dismiss()
//                print(result)
//                let code = result["code"].intValue
//                if code == 200 {
//                    print(result)
//                    self.view.makeToast("取消成功")
//                    self.requestData(idx: self.segSort.selectedSegmentIndex)
//                }
//            }
//            payContainer.payHandler = { result in
//                print(result)
//                let code = result["code"].intValue
//                if code == 200 {
//                    let dataStr = result["data"].stringValue
//                    UserDefaults.standard.set(dataStr, forKey: "payURL")
//                    let vc = DoPayView()
//                    let naviVC = UINavigationController(rootViewController: vc)
//                    self.present(naviVC, animated: true, completion: nil)
//                } else {
//                    self.toastMSG(result: result)
//                }
//            }
//            
//            _ = payPopup.show(payContainer)
//            payDelegate = payContainer.self
//            let orderNo = cellData["orderNo"] as? String
//            payDelegate?.orderToPay(orderNo: orderNo!)
//        }
//    }
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
        
        let strYear = String.init(format: "%d",year!)
        let strMonth = String.init(format: "%d",month!)
        
        let idx = ordersViewPage?.currentIndex
        let vc = ordersViewPage?.viewControllers[idx!] as! OrdersList
        ordersViewPage?.setTimeRange(year: strYear, month: strMonth)
        vc.reNewRange(type: idx!, year: strYear, month: strMonth)
    }
}
