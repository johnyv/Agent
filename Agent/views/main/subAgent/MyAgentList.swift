//
//  MyAgentList.swift
//  Agent
//
//  Created by 于劲 on 2017/12/19.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class MyAgentList: UITableViewController, IndicatorInfoProvider {

    var pageInfo = IndicatorInfo(title: "Page")
    
    var listData = [[String:Any]]()

    let cellTitleIdentifier = "titleCell"
    let cellDetailIdentifier = "detailCell"

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
        tableView.tableFooterView = UIView()
        
        tableView.register(MyAgentListTitle.self, forCellReuseIdentifier: cellTitleIdentifier)
        let xibTitle = UINib(nibName: "MyAgentListTitle", bundle: nil)
        tableView.register(xibTitle, forCellReuseIdentifier: cellTitleIdentifier)

        tableView.register(MyAgentListCell.self, forCellReuseIdentifier: cellDetailIdentifier)
        let xibCell = UINib(nibName: "MyAgentListCell", bundle: nil)
        tableView.register(xibCell, forCellReuseIdentifier: cellDetailIdentifier)

        request(.myagent(agentType: 0, page: 1, pageSize: 0), success: handleResult)
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTitleIdentifier, for: indexPath) as! MyAgentListTitle
            let cellData = listData[indexPath.row]
            
            cell.backgroundColor = UIColor(hex: "dddddd")
            cell.selectionStyle = .none
            cell.lblAgentType.text = cellData["agentType"] as? String
            cell.lblAgentCard.text = cellData["agentCard"] as? String
            cell.lblLastBuyTime.text = cellData["lastBuyTime"] as? String
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDetailIdentifier, for: indexPath) as! MyAgentListCell
            let cellData = listData[indexPath.row]
            
            //cell.backgroundColor = UIColor(hex: "dddddd")
            cell.selectionStyle = .none
            cell.lblNickName.text = cellData["nickName"] as? String
            let id = cellData["agentId"] as! Int
            cell.lblUserId.text = String.init(format: "ID:%d", id)
            let strURL = cellData["headerImgSrc"] as! String
            let hold = cellData["agentCard"] as! Int
            cell.lblHoldCount.text = String.init(format: "%d", hold)
            cell.lblLastTime.text = cellData["lastBuyTime"] as? String
            return cell

        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 25
        default:
            return 44
        }
    }

    func handleResult(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            listData.removeAll()
            let title = ["agentType":"代理",
                         "agentCard":"库存",
                         "lastBuyTime":"最后购卡时间"]
            listData.append(title)
            
            let data = result["data"]
            let dataArr = data["myAgentList"].array
            for(_, element) in (dataArr?.enumerated())!{
                var item:[String:Any] = [:]
                item["agentId"] = element["agentId"].intValue
                item["headerImgSrc"] = element["headerImgSrc"].stringValue
                item["nickName"] = element["nickName"].stringValue
                item["agentType"] = element["agentType"].stringValue
                item["agentCard"] = element["agentCard"].intValue
                item["lastBuyTime"] = element["lastBuyTime"].stringValue
                
                listData.append(item)
            }
            tableView.reloadData()
        } else {
        }
    }

//    func tt(){
//        let title = ["agentType":"代理",
//                     "agentCard":"库存",
//                     "lastBuyTime":"最后购卡时间"]
//        
//        listData.append(title)
//        tableView.reloadData()
//    }
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
