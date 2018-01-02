//
//  MyAgentRecords.swift
//  Agent
//
//  Created by 于劲 on 2017/12/23.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class DealRecords: UIViewController {

    var imgHeadIco:UIImageView!
    var lblNickName:UILabel!
    var lblAgentID:UILabel!
    @IBOutlet weak var lblTimes:UILabel!
    @IBOutlet weak var lblCount:UILabel!
    
//    var customerType:Int = 0
    var subAgentId:Int = 0
    
    let cellDetailIdentifier = "detailCell"
    var tableView:UITableView!
    
    var listData = [[String:Any]]()
    var totalData = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        imgHeadIco = addImageView()
        imgHeadIco.frame.origin.y = 5
        
        //let agent = AgentSession.shared.agentModel
        
//        let strURL = agent?.headImg
//        if (strURL != nil) {
//            let icoURL = URL(string: strURL!)
//            imgHeadIco.sd_setImage(with: icoURL, completed: nil)
//        } else {
            imgHeadIco.image = UIImage(named: "headsmall")
//        }
        
        lblNickName = addLabel(title: "")
        lblNickName.frame.origin.x = imgHeadIco.frame.origin.x + imgHeadIco.frame.width + 5
        lblNickName.frame.origin.y = imgHeadIco.frame.origin.y
//        let nickName = agent?.nickName
//        lblNickName.text = nickName
        
        lblAgentID = addLabel(title: "")
        lblAgentID.frame.origin.x = imgHeadIco.frame.origin.x + imgHeadIco.frame.width + 5
        lblAgentID.frame.origin.y = lblNickName.frame.origin.y + lblNickName.frame.height
        
//        let agentID = agent?.agentId
//        lblAgentID.text = String.init(format: "ID:%d", agentID!)
        
        lblTimes = addLabel(title: "")
        lblTimes.frame.origin.y = imgHeadIco.frame.origin.y + imgHeadIco.frame.height + 15
        let line1 = addUnderLine(v: lblTimes)
        lblCount = addLabel(title: "")
        lblCount.frame.origin.y = line1.frame.origin.y + line1.frame.height + 5
        
        let y = lblCount.frame.origin.y + lblCount.frame.height + 5
        let div = addDivLine(y: y)
        
        let tbRC = CGRect(x: 0, y: div.frame.origin.y + 5, width: view.bounds.width, height: view.bounds.height - div.frame.origin.y)
        tableView = UITableView(frame: tbRC, style: .plain)
        
        let xib = UINib(nibName: "MyAgentInfoCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: cellDetailIdentifier)
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if self.subAgentId != 0 {
//            if self.customerType != 0 {
//                request(.recentlyAgent(searchId: self.subAgentId, startDate: 0, endDate: 0, sortType: 0, pageIndex: 0, pageNum: 0), success: handleDetail)
//            } else {
            request(.customerRecently(searchId: self.subAgentId, startDate: 0, endDate: 0, sortType: 0, pageIndex: 0, pageNum: 0), success: handleDetail)
//            }
            request(.customerTotallist(searchId: self.subAgentId, startDate: 0, endDate: 0, sortType: 3, pageIndex: 0, pageNum: 0), success: handleTotal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDetail(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            listData.removeAll()
            let data = result["data"]
            let dataArr = data["datas"].array
            for(_, data) in (dataArr?.enumerated())!{
                var cellData:[String:Any] = [:]
                cellData["id"] =  data["id"].intValue
                cellData["nick"] =  data["nick"].stringValue
                cellData["header_img_src"] =  data["header_img_src"].stringValue
                cellData["customerType"] =  data["customerType"].stringValue
                cellData["cardNum"] =  data["cardNum"].intValue
                cellData["sellTime"] =  data["sellTime"].stringValue
                cellData["sellCount"] = data["sellCount"].intValue
                
                listData.append(cellData)
            }
            tableView.reloadData()
            if listData.count < 1 {
                view.makeToast("暂无数据", duration: 2, position: .center)
            }
        }
    }

    func handleTotal(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            totalData.removeAll()
            let data = result["data"]
            let dataArr = data["datas"].array
            for(_, data) in (dataArr?.enumerated())!{
                var cellData:[String:Any] = [:]
                cellData["id"] =  data["id"].intValue
                cellData["nick"] =  data["nick"].stringValue
                cellData["header_img_src"] =  data["header_img_src"].stringValue
                cellData["customerType"] =  data["customerType"].stringValue
                cellData["cardNum"] =  data["cardNum"].intValue
                cellData["sellTime"] =  data["sellTime"].stringValue
                cellData["sellCount"] = data["sellCount"].intValue
                
                totalData.append(cellData)
            }
            if totalData.count > 0 {
                let data0 = totalData[0]
                //self.title = String.init(format: "%s的明细", data0["nick"] as! String)
                self.title = (data0["nick"] as? String)! + "的明细"

                let strURL = data0["header_img_src"] as? String
                if strURL != "" {
                    let icoURL = URL(string: strURL!)
                    imgHeadIco.sd_setImage(with: icoURL, completed: nil)
                }

                lblAgentID.text = String.init(format: "ID:%d", data0["id"] as! Int)
                lblNickName.text = data0["nick"] as? String
                lblTimes.text = String.init(format: "购卡次数: %d", data0["sellCount"] as! Int)
                lblCount.text = String.init(format: "购卡张数: %d", data0["cardNum"] as! Int)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension DealRecords: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDetailIdentifier, for: indexPath) as! MyAgentInfoCell
        let cellData = listData[indexPath.row]
        cell.lblTitle.text = cellData["sellTime"] as? String
        cell.lblContent.text = String.init(format: "%d张", cellData["cardNum"] as! Int)
        return cell
    }
}
