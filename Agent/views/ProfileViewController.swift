//
//  ProfileViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/9.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

protocol ModifyProfileDelegage{
    func refresh()
}

class ProfileViewController: UITableViewController, ModifyProfileDelegage {
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
    var profile:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.tableFooterView = UIView()
//        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
//            .textColor = UIColor.gray
//        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
//            .font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)
        //self.tableView.style = .grouped
//        tableView.estimatedRowHeight = 44
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellNormalIdentifier)
        tableView.register(ProfileHeadCell.self, forCellReuseIdentifier: cellHeadIdentifier)
        let xibHead = UINib(nibName: "ProfileHeadCell", bundle: nil)
        tableView.register(xibHead, forCellReuseIdentifier: cellHeadIdentifier)

//        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: cellOptionIdentifier)
//        let xibOpt = UINib(nibName: "ProfileOptionCell", bundle: nil)
//        tableView.register(xibOpt, forCellReuseIdentifier: cellOptionIdentifier)

        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: cellInfoIdentifier)
        let xibInfo = UINib(nibName: "ProfileInfoCell", bundle: nil)
        tableView.register(xibInfo, forCellReuseIdentifier: cellInfoIdentifier)
        
        tableView.bounces = false

        request(.myInfo, success: handleInfo)

        autoFit()
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
            let strURL = profile["headerImgSrc"]
            if strURL != nil {
                if strURL as! String != "" {
                    let icoURL = URL(string: strURL as! String)
                    cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
                }else{
                    cell.imgHeadIco.image = UIImage(named: "headsmall")
                }
            }
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellInfoIdentifier) as! ProfileInfoCell
            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
            cell.btnOpt.isHidden = true
            cell.selectionStyle = .none
            if (indexPath.section == 1 && indexPath.row == 3) || (indexPath.section == 3 && indexPath.row == 0){
                cell.lblContent.isHidden = true
                cell.accessoryType = .disclosureIndicator
                //cell.selectionStyle = .default
            }
            switch indexPath.section {
            case 0:
                switch indexPath.row{
                case 1:
                    cell.lblContent.text = profile["nickName"] as? String
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                case 2:
                    cell.lblContent.text = profile["account"] as? String
                case 3:
                    cell.lblContent.text = profile["agentId"] as? String
                default:
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    if profile["proofName"] != nil{
                        let proofName = profile["proofName"] as! String
                        if proofName != "" {
                            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
                            cell.lblContent.text = proofName
                        }else{
                            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
                            cell.btnOpt.isHidden = false
                            cell.btnOpt.addTarget(self, action: #selector(self.doProof(_:)), for: .touchUpInside)
                            cell.lblContent.isHidden = true
                            cell.btnOpt.setTitle(titleBtns[indexPath.row], for: .normal)
                            cell.accessoryType = .disclosureIndicator
                        }
                    }
                case 1:
                    if profile["bindTel"] != nil{
                        let bindTel = profile["bindTel"] as! String
                        if bindTel != "" {
                            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
                            cell.lblContent.text = bindTel
                            cell.accessoryType = .disclosureIndicator
                        }else{
                            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
                            cell.btnOpt.isHidden = false
                            cell.btnOpt.addTarget(self, action: #selector(self.doBind(_:)), for: .touchUpInside)
                            cell.lblContent.isHidden = true
                            cell.btnOpt.setTitle(titleBtns[indexPath.row], for: .normal)
                            cell.accessoryType = .disclosureIndicator
                        }
                    }
                case 2:
                    if profile["weChatLogin"] != nil{
                        let weChatLogin = profile["weChatLogin"] as! Bool
                        if weChatLogin == true {
                            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
                            cell.lblContent.text = "已授权"
                            cell.selectionStyle = .none
                        }else{
                            cell.lblCaption.text = profileCaps[indexPath.section][indexPath.row]
                            cell.btnOpt.isHidden = false
                            cell.btnOpt.addTarget(self, action: #selector(self.doWeixinAuth(_:)), for: .touchUpInside)
                            cell.lblContent.isHidden = true
                            cell.btnOpt.setTitle(titleBtns[indexPath.row], for: .normal)
                            cell.accessoryType = .disclosureIndicator
                        }
                    }
                default:
                    break
                }
                
            case 2:
                switch indexPath.row{
                case 0:
                    cell.lblContent.text = profile["gameName"] as? String
                case 1:
                    cell.lblContent.text = profile["serverCity"] as? String
                case 2:
                    cell.lblContent.text = profile["createTime"] as? String
                case 3:
                    cell.lblContent.text = profile["agentType"] as? String
                default:
                    break
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = ModifyHeadImageView()
                let naviVC = UINavigationController(rootViewController: vc)
                present(naviVC, animated: true, completion: nil)
                
            case 1:
                let vc = ModifyNickView()
                vc.delegateModify = self
                let naviVC = UINavigationController(rootViewController: vc)
                present(naviVC, animated: true, completion: nil)
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 1:
                let vc = loadVCfromMain(identifier: "modifyTelView") as! ModifyTelView
                vc.delegateModify = self
                present(vc, animated: true, completion: nil)
            case 3:
                let vc = ModifyPasswordView()
                let naviVC = UINavigationController(rootViewController: vc)
                present(naviVC, animated: true, completion: nil)
                
            default:
                break
            }
            
        case 3:
            switch indexPath.row {
            case 0:
                let vc = loadVCfromMain(identifier: "aboutView") as! AboutView
                present(vc, animated: true, completion: nil)
                
            default:
                break
            }
            
        default:
            break
        }
    }
    
//    func requestInfo(){
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
//        
//        Network.request(.myInfo, success: handleInfo, provider: provider)
//    }
    
    func handleInfo(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            let data = result["data"]
            profile = getProfileFromJSON(data: data)
            setProfile(data: data)
//            profile["headerImgSrc"] = data["headerImgSrc"].stringValue
//            profile["nickName"] = data["nickName"].stringValue
//            profile["account"] = data["account"].stringValue
//            profile["agentId"] = data["agentId"].stringValue
//            profile["proofName"] = data["proofName"].stringValue
//            profile["bindTel"] = data["bindTel"].stringValue
//            profile["weChatLogin"] = data["weChatLogin"].boolValue
//            profile["gameName"] = data["gameName"].stringValue
//            profile["serverCity"] = data["serverCity"].stringValue
//            profile["createTime"] = data["createTime"].stringValue
//            profile["cardCount"] = data["cardCount"].intValue
//            profile["agentType"] = data["agentType"].stringValue
            
            tableView.reloadData()
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.reLogin()
    }
    @IBAction func backToIndex(_ sender: UIBarButtonItem) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.menuTab?.selectedIndex = 0
    }
    
    func doProof(_ sender:UIButton){
        alertResult(code: 99)
    }

    func doBind(_ sender:UIButton){
        let vc = loadVCfromMain(identifier: "bindTelView") as! BindTelView
        present(vc, animated: true, completion: nil)
    }

    func doWeixinAuth(_ sender:UIButton){
        alertResult(code: 99)
    }

    func refresh() {
        request(.myInfo, success: handleInfo)
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
