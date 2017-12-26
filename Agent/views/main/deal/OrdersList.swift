//
//  OrdersListView.swift
//  Agent
//
//  Created by 于劲 on 2017/11/29.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip
import PopupController

class OrdersList: UITableViewController, PageListDelegate, IndicatorInfoProvider {

    var pageInfo = IndicatorInfo(title: "Page")
    
    var listData = [[String:Any]]()
    
    let cellDetailIdentifier = "detailCell"
    
    var pageDelegate:PageListDelegate?
    var type:Int?
    
    var imageNodata:UIImageView!
    var lblNoData:UILabel!

    var payDelegate:PayOrderDelegate?

    init(style: UITableViewStyle, pageInfo: IndicatorInfo) {
        self.pageInfo = pageInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let xib = UINib(nibName: "OrderListCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: cellDetailIdentifier)

        tableView.tableFooterView = UIView()
        
        imageNodata = addImageView()
        imageNodata.image = UIImage(named: "myagency")
        imageNodata.frame.size = CGSize(width: 185, height: 177)
        imageNodata.frame.origin.y = 65//view.frame.height/3 - imageNodata.frame.height
        alignUIView(v: imageNodata, position: .center)
        
        lblNoData = addLabel(title: "暂无数据")
        lblNoData.frame.origin.y = imageNodata.frame.origin.y + imageNodata.frame.height + 25
        lblNoData.font = UIFont.systemFont(ofSize: 20)
        lblNoData.textAlignment = .center
        alignUIView(v: lblNoData, position: .center)
        
        showNoData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDetailIdentifier, for: indexPath) as! OrderListCell

        // Configure the cell...
        let cellData = listData[indexPath.row]
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
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = listData[indexPath.row]
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
                    self.view.makeToast("取消成功", duration: 2, position: .center)
                    self.pageDelegate?.reNew(type: self.type!)
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

    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            listData.removeAll()
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
                listData.append(item)
            }
//            DispatchQueue.main.async(execute: { () -> Void in
            tableView.reloadData()
            showNoData()
//            })
        }
    }
    
    func showNoData(){
        if listData.count > 0{
            imageNodata.isHidden = true
            lblNoData.isHidden = true
        } else {
            imageNodata.isHidden = false
            lblNoData.isHidden = false
        }
    }

    func reNew(type: Int) {
        self.type = type
        let range = type + 1
        
        let calender = Calendar(identifier: .gregorian)
        var comps:DateComponents = DateComponents()
        let date = Date()
        comps = calender.dateComponents([.year, .month], from: date)
        let year = comps.year
        let month = comps.month

//        request(.orderlist(year: "2017", month: "12", page: "1", type: type), success: handleData)
        request(.orderlist(year: String.init(format: "%d",year!), month: String.init(format: "%d",month!), page: "1", type: String(range)), success: handleData)
    }
    
    public func reNewRange(type:Int, year:String, month:String){
        self.type = type
        let range = type + 1
        
        request(.orderlist(year: year, month: month, page: "1", type: String(range)), success: handleData)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return pageInfo
    }
}
