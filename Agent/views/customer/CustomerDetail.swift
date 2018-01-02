//
//  CustomerDetail.swift
//  Agent
//
//  Created by 于劲 on 2017/12/25.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import MJRefresh

class CustomerDetail: UITableViewController, PageListDelegate, IndicatorInfoProvider {

    var pageInfo = IndicatorInfo(title: "Page")
    
    var listData = [[String:Any]]()
    
    let cellDetailIdentifier = "detailCell"
    
    var delegate:PageListDelegate?
    var type:Int?
    var page:Int?
    var imageNodata:UIImageView!
    var lblNoData:UILabel!
    
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
        let xib = UINib(nibName: "CustomerTableCell", bundle: nil)
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
        
        self.page = 0
        let mjRefresh = MJRefreshNormalHeader()
        mjRefresh.setRefreshingTarget(self, refreshingAction: #selector(self.doMJRefresh))
        tableView.mj_header = mjRefresh
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDetailIdentifier, for: indexPath) as! CustomerTableCell

        // Configure the cell...
        let cellData = listData[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        let strURL = cellData["header_img_src"] as! String
        if strURL == "" {
            cell.imgHeadIco.image = UIImage(named: "headsmall")
        } else {
            let icoURL = URL(string: strURL.convertToHttps())
            cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        }
        cell.lblUserId.text = String.init(format: "ID:%d", cellData["id"] as! Int)
        cell.lblNickName.text = cellData["nick"] as? String
        cell.lblCount.text = String.init(format: "%d张", cellData["cardNum"] as! Int)

        if self.type! > 0 {
            cell.lblTime.text = String.init(format: "%d次", cellData["sellCount"] as! Int)
        } else {
            cell.lblTime.text = cellData["sellTime"] as? String
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = listData[indexPath.row]
        let id = cellData["id"] as! Int
        let vc = DealRecords()
        vc.subAgentId = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleResult(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
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
            tableView.mj_header.endRefreshing()
            showNoData()
        }
    }

    func doMJRefresh(){
        self.page = self.page! + 1
        reNew(type: self.type!)
    }
    
    func reNew(type: Int) {
        self.type = type
        switch type {
        case 0:
            request(.customerRecently(searchId: 0, startDate: 0, endDate: 0, sortType: 0, pageIndex: 0, pageNum: self.page!), success: handleResult)
        case 1:
            request(.customerTotallist(searchId: 0, startDate: 0, endDate: 0, sortType: 3, pageIndex: 0, pageNum: self.page!), success: handleResult)
        case 2:
            request(.customerTotallist(searchId: 0, startDate: 0, endDate: 0, sortType: 2, pageIndex: 0, pageNum: self.page!), success: handleResult)
        default:
            break
        }
    }
    
    func reNewByID(type:Int, searchId:Int, startDate: Int, endDate:Int) {
        print(startDate)
        print(endDate)
        self.type = type
        switch type {
        case 0:
            request(.customerRecently(searchId: searchId, startDate: startDate, endDate: endDate, sortType: 0, pageIndex: 0, pageNum: self.page!), success: handleResult)
        case 1:
            request(.customerTotallist(searchId: searchId, startDate: startDate, endDate: endDate, sortType: 3, pageIndex: 0, pageNum: self.page!), success: handleResult)
        case 2:
            request(.customerTotallist(searchId: searchId, startDate: startDate, endDate: endDate, sortType: 2, pageIndex: 0, pageNum: self.page!), success: handleResult)
        default:
            break
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
