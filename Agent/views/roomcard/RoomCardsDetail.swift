//
//  RoomCardsDetail.swift
//  Agent
//
//  Created by 于劲 on 2017/12/25.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class RoomCardsDetail: UITableViewController, PageListDelegate, IndicatorInfoProvider {

    var pageInfo = IndicatorInfo(title: "Page")
    
    var listData = [[String:Any]]()
    
    let cellDetailIdentifier = "detailCell"
    
    var delegate:PageListDelegate?
    var type:Int?
    
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
        let xib = UINib(nibName: "RoomCardDetailCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: cellDetailIdentifier)
        tableView.tableFooterView = UIView()
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
        switch indexPath.row {
        case 0:
            return 25
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDetailIdentifier, for: indexPath) as! RoomCardDetailCell

        // Configure the cell...
        let cellData = listData[indexPath.row]
        cell.selectionStyle = .none
        cell.lblCol1.textAlignment = .left
        cell.lblCol2.textAlignment = .center
        cell.lblCol3.textAlignment = .center
        cell.lblCol4.textAlignment = .center
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(hex: "cccccc")
            cell.lblCol1.textColor = UIColor.black
            cell.lblCol2.textColor = UIColor.black
            cell.lblCol3.textColor = UIColor.black
            cell.lblCol4.textColor = UIColor.black
        }else{
            cell.lblCol1.textAlignment = .left
            cell.lblCol4.textAlignment = .right
        }
        
        cell.lblCol1.text = cellData["col1"] as? String
        cell.lblCol2.text = cellData["col2"] as? String
        cell.lblCol3.text = cellData["col3"] as? String
        cell.lblCol4.text = cellData["col4"] as? String

        return cell
    }
    
    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            listData.removeAll()
            var title:[String:Any] = [:]
            if self.type == 0 {
                title = ["col1":"类型",
                         "col2":"房卡数",
                         "col3":"ID",
                         "col4":"时间"]
            } else {
                title = ["col1":"类型",
                         "col2":"房卡数",
                         "col3":"金额",
                         "col4":"时间"]
            }
            listData.append(title)
            
            let data = result["data"]
            let dataArr = data["datas"].array
//            let sort = segSort.selectedSegmentIndex
            for(_, element) in (dataArr?.enumerated())!{
                var item:[String:Any] = [:]
                if type == 0 {
                    item["col1"] = element["sellType"].stringValue
                    item["col2"] = element["cardNum"].stringValue
                    item["col3"] = element["id"].stringValue
                    item["col4"] = element["sellTime"].stringValue
                    
//                    listData.append(CardDetailCellModel(col1: data["sellType"].stringValue, col2: data["cardNum"].stringValue, col3: data["id"].stringValue, col4: data["sellTime"].stringValue))
                }else{
                    item["col1"] = element["buyWay"].stringValue
                    item["col2"] = element["cardNum"].stringValue
                    item["col3"] = element["amount"].stringValue
                    item["col4"] = element["time"].stringValue

//                    listData.append(CardDetailCellModel(col1: data["buyWay"].stringValue, col2: data["cardNum"].stringValue, col3: data["amount"].stringValue, col4: data["time"].stringValue))
                }
                listData.append(item)
            }
            tableView.reloadData()
//            let count = listData.count
//            showNodata(dataCount: count)
        }
    }

    func reNew(type: Int) {
        self.type = type
        let timeInterVal = Int(Date().timeIntervalSince1970*1000)
        if type == 0 {
            request(.statisticList(time: String(timeInterVal), sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
        } else {
            request(.goodDetail(time: String(timeInterVal), page: 1), success: handleData)
        }
    }
    
    public func refreshDate(time:Int) -> Void {
        if self.type == 0 {
            request(.statisticList(time: String(time), sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
        } else {
            request(.goodDetail(time: String(time), page: 1), success: handleData)
        }
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
