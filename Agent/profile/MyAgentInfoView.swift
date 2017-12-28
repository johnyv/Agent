//
//  MyAgentInfoView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyAgentInfoView: UITableViewController {
    let cellInfoIdentifier = "infoCell"

    let infoTitles = [
        "特权类型", "有效期", /*"开通代理",*/ "向玩家售卡", "向代理售卡", "开通数量", "购卡折扣"
    ]

    var agentInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "代理特权"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.register(MyAgentInfoCell.self, forCellReuseIdentifier: cellInfoIdentifier)
        let xibInfo = UINib(nibName: "MyAgentInfoCell", bundle: nil)
        tableView.register(xibInfo, forCellReuseIdentifier: cellInfoIdentifier)
        tableView.tableFooterView = UIView()

        request(.typeInfo, success: handleResult)
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
        return infoTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellInfoIdentifier, for: indexPath) as! MyAgentInfoCell

        // Configure the cell...
        cell.selectionStyle = .none
        cell.lblTitle.text = infoTitles[indexPath.row]
        if agentInfo.count > indexPath.row {
            cell.lblContent.text = agentInfo[indexPath.row]
        }
        return cell
    }

    func handleResult(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            agentInfo.removeAll()
            
            let data = result["data"]
            agentInfo.append(data["type"].stringValue)
            agentInfo.append(data["validityPeriod"].stringValue)
//            agentInfo.append(data["createAgent"].stringValue)
            agentInfo.append(data["buyOnline"].stringValue)
            agentInfo.append(data["createAgent"].stringValue)
            agentInfo.append(data["subordinateNum"].stringValue)
            agentInfo.append(data["discount"].stringValue)
            
            tableView.reloadData()
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

}
