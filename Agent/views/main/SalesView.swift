//
//  SalesViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/15.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class SalesView: UIViewController {

    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    
    let cellTableIdentifier = "customerTableCell"
    var sourceData = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "售卡"
        // Do any additional setup after loading the view.
        segSort.selectedSegmentIndex = 0
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
        btnSearch.addTarget(self, action: #selector(self.doSearch(_:)), for: .touchUpInside)
        
        requestData(sort: segSort.selectedSegmentIndex)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomerTableCell.self, forCellReuseIdentifier: cellTableIdentifier)
        let xib = UINib(nibName: "CustomerTableCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: cellTableIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 65
        
        tfSearch.keyboardType = .numberPad
        
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segDidchange(_ segmented:UISegmentedControl){
        print(segmented.selectedSegmentIndex)
        tfSearch.text = ""
        requestData(sort: segmented.selectedSegmentIndex)
    }

    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func doSearch(_ sender:UIButton){
        let id = Int(tfSearch.text!)
        if id == nil {
            view.makeToast("Id不能为空", duration: 2, position: .center)
            return
        }
        let sort = segSort.selectedSegmentIndex
        switch sort {
        case 0:
            request(.playerSearch(searchId: id!), success: handleSearch)
        case 1:
            request(.agentSearch(searchId: id!), success: handleSearch)
        default:
            break
        }
    }
    
    func requestData(sort:Int){
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
        
        if sort == 0 {
            request(.recentlyPlayer(searchId: 0, startDate: 0, endDate: 0, sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
//            Network.request(.recentlyPlayer(searchId: 0, startDate: 0, endDate: 0, sortType: 0, pageIndex: 0, pageNum: 0), success: handleData, provider: provider)
            
        }else
        {
            request(.recentlyAgent(searchId: 0, startDate: 0, endDate: 0, sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
//            Network.request(.recentlyAgent(searchId: 0, startDate: 0, endDate: 0, sortType: 0, pageIndex: 0, pageNum: 0), success: handleData, provider: provider)
        }
    }
    
    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            sourceData.removeAll()
            print(result)
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
                sourceData.append(cellData)

            }
            tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let sort = segSort.selectedSegmentIndex
        switch sort {
        case 0:
            request(.playerSearch(searchId: Int(searchText)!), success: handleSearch)
        case 1:
            request(.agentSearch(searchId: Int(searchText)!), success: handleSearch)
        default:
            break
        }
    }
    
    func handleSearch(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        print(result)
        if code == 200 {
            let data = result["data"]
            var cellData:[String:Any] = [:]
            let sort = segSort.selectedSegmentIndex
            cellData["nick"] =  data["nick"].stringValue
            if sort == 0 {
                cellData["id"] =  data["playerId"].intValue
                cellData["header_img_src"] =  data["headImageUrl"].stringValue
                cellData["customerType"] =  "P"
//            cellData["customerType"] =  data["customerType"].stringValue
//            cellData["cardNum"] =  data["cardNum"].intValue
//            cellData["sellTime"] =  data["sellTime"].stringValue
//            cellData["sellCount"] = data["sellCount"].intValue
            } else {
                cellData["id"] =  data["id"].intValue
                cellData["header_img_src"] =  data["header_img_src"].stringValue
                cellData["customerType"] =  "A"
            }
            
            let vc = loadVCfromMain(identifier: "salesConfirmView") as! SalesConfirmView
            vc.delegate = vc.self
            let nick = cellData["nick"] as! String
            let headIco = cellData["header_img_src"] as! String
            let id = cellData["id"] as! Int
            let type = cellData["customerType"] as! String

            vc.delegate?.confirmInfo(nick: nick, headIco: headIco, id: id, type: type)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            toastMSG(result: result)
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

extension SalesView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! CustomerTableCell
        
        // Configure the cell...
        let cellData = sourceData[indexPath.row]
        //        cell.accessoryType = .disclosureIndicator
        //        cell.selectionStyle = .none
        let strURL = cellData["header_img_src"] as! String
        if strURL == "" {
            cell.imgHeadIco.image = UIImage(named: "headsmall")
        } else {
            let icoURL = URL(string: strURL)
            cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        }
        //        let icoURL = URL(string: cellData.header_img_src)
        //        cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        cell.lblUserId.text = String.init(format: "ID:%d", cellData["id"] as! Int)
        cell.lblNickName.text = cellData["nick"] as? String
        cell.lblCount.isHidden = true
        cell.lblTime.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = sourceData[indexPath.row]
        let vc = loadVCfromMain(identifier: "salesConfirmView") as! SalesConfirmView
        vc.delegate = vc.self

        let nick = cellData["nick"] as! String
        let headIco = cellData["header_img_src"] as! String
        let id = cellData["id"] as! Int
        let type = cellData["customerType"] as! String
        
        vc.delegate?.confirmInfo(nick: nick, headIco: headIco, id: id, type: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
