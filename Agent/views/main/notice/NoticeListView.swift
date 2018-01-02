//
//  NoticeListView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/20.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class NoticeListView: UITableViewController {

    let cellTableIdentifier = "commonCell"
    var sourceData = [[[String:Any]]]()

    var page:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "公告列表"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellTableIdentifier)
        tableView.tableFooterView = UIView()
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.systemFont(ofSize: 10.0)
        
        self.page = 0
        let mjRefresh = MJRefreshNormalHeader()
        mjRefresh.setRefreshingTarget(self, refreshingAction: #selector(self.doMJRefresh))
        tableView.mj_header = mjRefresh

        request(.noticeList(page: self.page!, pageSize: 0), success: handleData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sourceData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let data = sourceData[section]
        return data.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = sourceData[section]
        return data[0]["createTime"] as? String
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = loadVCfromMain(identifier: "noticeDetailView") as! NoticeDetailView
        let dataSelected = sourceData[indexPath.section][indexPath.row]
        print(dataSelected)
        let vc = NoticeDetailView()
        vc.noticeId = dataSelected["id"] as? Int
        print(vc.noticeId)
        navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath)

        // Configure the cell...
        cell.accessoryType = .disclosureIndicator
        
        let data = sourceData[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.textLabel?.text = data["title"] as? String
        
        return cell
    }

    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {

            sourceData.removeAll()
            let data = result["data"]
            let dataArr = data["noticeList"].array
            for(_, element) in (dataArr?.enumerated())!{
                var item:[String:Any] = [:]
                item["id"] = element["id"].intValue
                item["title"] = element["title"].stringValue
                item["createTime"] = element["createTime"].stringValue

                sourceData.append([item])
            }
            
            tableView.reloadData()
            tableView.mj_header.endRefreshing()
        }
    }
    
    func doMJRefresh(){
        self.page = self.page! + 1
        request(.noticeList(page: self.page!, pageSize: 0), success: handleData)
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

}
