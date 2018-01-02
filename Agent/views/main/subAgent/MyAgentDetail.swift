//
//  MyAgentDetail.swift
//  Agent
//
//  Created by 于劲 on 2017/12/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol MyAgentDetailDelegate {
    func subAgent(id:Int)
    func reLoad()
}

class MyAgentDetail: UITableViewController, MyAgentDetailDelegate {
    let cellRemarkIdentifier = "remarkCell"

    var subAgentId:Int?
    var isEnabled:Bool?
    var delegate:MyAgentDetailDelegate?
    @IBOutlet weak var tfRemark:UITextField?
    @IBOutlet weak var btnSwitch:UIButton?
    let infoTitles = [
        "代理ID", "所属游戏", "类型", "激活时间", "安全手机", "登录账号", "备注"
    ]

    var agentInfo = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "代理信息"
        let rightButton = UIBarButtonItem(title: "购卡详情", style: .plain, target: self, action: #selector(cardsDetail(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

//        tableView.register(MyAgentRemarkCell.self, forCellReuseIdentifier: cellRemarkIdentifier)
        let xib = UINib(nibName: "MyAgentRemarkCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: cellRemarkIdentifier)

        tableView.tableFooterView = UIView()
        
        btnSwitch = addButton(title: "禁用该代理", action: #selector(agentSwitch(_:)))
        btnSwitch?.frame.origin.y = UIScreen.main.bounds.height/2 + 25
        btnSwitch?.setBorder(type: 0)
        
        request(.myagentInfo(subAgentId: self.subAgentId!), success: handleResult)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRemarkIdentifier, for: indexPath) as! MyAgentRemarkCell
        cell.selectionStyle = .none
        cell.tfRemark.isHidden = true
        cell.btnSave.isHidden = true
        
        // Configure the cell...
        cell.lblTitle.text = infoTitles[indexPath.row]
        
        if agentInfo.count > 0 {
            let cellData = agentInfo[indexPath.row]
            switch indexPath.row {
            case 0:
                let agentId = cellData as! Int
                cell.lblContent.text = String.init(format: "%d", agentId)

            case 4:
                let isBind = cellData as! Bool
                if isBind {
                    cell.lblContent.text = "已绑定"
                } else {
                    cell.lblContent.text = "未绑定"
                }
            case 6:
                let remark = cellData as! String
                cell.tfRemark.text = remark
//                if remark == "" {
                    cell.lblContent.isHidden = true
                    cell.tfRemark.isHidden = false
                    tfRemark = cell.tfRemark
                    cell.btnSave.isHidden = false
                    cell.btnSave.addTarget(self, action: #selector(remark(_:)), for: .touchUpInside)
//                } else {
//                    cell.lblContent.isHidden = false
//                    cell.lblContent.text = remark
//                    cell.tfRemark.isHidden = true
//                    cell.btnSave.isHidden = true
//                }
                
            default:
                cell.lblContent.text = cellData as? String
            }
        }
        return cell
    }
    
    func cardsDetail(_ sender:Any){
        let vc = DealRecords()
        vc.subAgentId = self.subAgentId!
        navigationController?.pushViewController(vc, animated: true)
    }

    func agentSwitch(_ sender:Any){
        var enable:String?
        
        if self.isEnabled! {
            enable = "N"
        } else {
            enable = "Y"
        }
        request(.agentSwitch(agentId: self.subAgentId!, enable: enable!), success: handleSwitch)
    }
    
    func handleSwitch(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            super.view.makeToast("保存成功")
            delegate?.reLoad()
        }
    }
    
    func handleResult(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            agentInfo.removeAll()
            
            let data = result["data"]
            agentInfo.append(data["agentId"].intValue)
            agentInfo.append(data["gameName"].stringValue)
            agentInfo.append(data["agentType"].stringValue)
            agentInfo.append(data["enableTime"].stringValue)
            agentInfo.append(data["isbindTel"].boolValue)
            agentInfo.append(data["account"].stringValue)
            agentInfo.append(data["remark"].stringValue)
            let enable = data["enable"].stringValue
            agentInfo.append(enable)
            
            if enable == "PY" || enable == "Y" {
                isEnabled = true
                btnSwitch?.setTitle("禁用该代理", for: .normal)
                btnSwitch?.backgroundColor = .orange
            } else {
                isEnabled = false
                btnSwitch?.setTitle("启用该代理", for: .normal)
                btnSwitch?.backgroundColor = UIColor(hex: "008ce6")
            }
            tableView.reloadData()
        }
    }
    
    func remark(_ sender:UIButton){
        let remark = tfRemark?.text
        request(.updateRemark(subAgentId: self.subAgentId!, remark: remark!), success: handleRemark)
    }
    
    func handleRemark(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            super.view.makeToast("保存成功")
        }
    }
    
    func subAgent(id: Int) {
        self.subAgentId = id
    }
    
    func reLoad() {
        request(.myagentInfo(subAgentId: self.subAgentId!), success: handleResult)
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
