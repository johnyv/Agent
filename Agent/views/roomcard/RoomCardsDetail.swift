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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            listData.removeAll()
            let data = result["data"]
            let dataArr = data["datas"].array
//            let sort = segSort.selectedSegmentIndex
            for(_, data) in (dataArr?.enumerated())!{
//                if sort == 0 {
//                    listData.append(CardDetailCellModel(col1: data["sellType"].stringValue, col2: data["cardNum"].stringValue, col3: data["id"].stringValue, col4: data["sellTime"].stringValue))
//                }else{
//                    listData.append(CardDetailCellModel(col1: data["buyWay"].stringValue, col2: data["cardNum"].stringValue, col3: data["amount"].stringValue, col4: data["time"].stringValue))
//                }
            }
            tableView.reloadData()
//            let count = listData.count
//            showNodata(dataCount: count)
        }
    }

    func reNew(type: Int) {
        let timeInterVal = Int(Date().timeIntervalSince1970*1000)
        if type == 0 {
            request(.statisticList(time: String(timeInterVal), sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
        } else {
            request(.goodDetail(time: String(timeInterVal), page: 1), success: handleData)
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
