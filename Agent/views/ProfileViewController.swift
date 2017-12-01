//
//  ProfileViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/9.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    let cellNormalIdentifier = "normalCell"
    let cellHeadIdentifier = "headCell"
    let cellInfoIdentifier = "infoCell"
    let cellOptionIdentifier = "optionCell"

    let profileCaps = [
        ["头像","昵称","登录账号","代理ID"],
        ["实名认证","安全手机","微信授权登录","密码管理"],
        ["游戏","服务城市","开通时间","代理特权"],
        ["关于"]
    ]
    
    let titleBtns = ["立即认证","立即绑定","立即授权"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // self.tableView.tableFooterView = UIView(frame:CGRect.zero)
//        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
//            .textColor = UIColor.gray
//        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
//            .font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)
        //self.tableView.style = .grouped
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellNormalIdentifier)
        tableView.register(ProfileHeadCell.self, forCellReuseIdentifier: cellHeadIdentifier)
        let xibHead = UINib(nibName: "ProfileHeadCell", bundle: nil)
        tableView.register(xibHead, forCellReuseIdentifier: cellHeadIdentifier)

        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: cellOptionIdentifier)
        let xibOpt = UINib(nibName: "ProfileOptionCell", bundle: nil)
        tableView.register(xibOpt, forCellReuseIdentifier: cellOptionIdentifier)

        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: cellInfoIdentifier)
        let xibInfo = UINib(nibName: "ProfileInfoCell", bundle: nil)
        tableView.register(xibInfo, forCellReuseIdentifier: cellInfoIdentifier)
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return profileCaps.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 3 {
            return 1
        }else{
            return 4
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.section == 0 && indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellHeadIdentifier) as! ProfileHeadCell
            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }else if (indexPath.section == 1 && indexPath.row == 0) ||
            (indexPath.section == 1 && indexPath.row == 1) ||
            (indexPath.section == 1 && indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOptionIdentifier, for: indexPath) as! ProfileOptionCell
            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
            cell.btnOpt.setTitle(titleBtns[indexPath.row], for: .normal)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellInfoIdentifier) as! ProfileInfoCell
            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            if (indexPath.section == 1 && indexPath.row == 3) || (indexPath.section == 3 && indexPath.row == 0){
            cell.lblContent.text = ""
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            }
            switch indexPath.section {
            case 0:
                switch indexPath.row{
                case 1:
                    cell.lblContent.text = AgentInfo.instance.nickName
                case 2:
                    cell.lblContent.text = AgentInfo.instance.roleId
                case 3:
                    cell.lblContent.text = AgentInfo.instance.agentId
                default:
                    cell.lblContent.text = ""
                }
            case 2:
                switch indexPath.row{
                case 0:
                    cell.lblContent.text = AgentInfo.instance.gameName
                case 1:
                    cell.lblContent.text = AgentInfo.instance.serverCode
                default:
                    cell.lblContent.text = ""
                }
            default: break
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return 65.0
        }else{
            return 45.0
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
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
