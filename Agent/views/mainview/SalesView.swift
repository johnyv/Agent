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

class SalesView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let cellTableIdentifier = "customerTableCell"
    var sourceData = [CustomerTableCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segSort.selectedSegmentIndex = 0
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
        
        requestData(sort: segSort.selectedSegmentIndex)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomerTableCell.self, forCellReuseIdentifier: cellTableIdentifier)
        let xib = UINib(nibName: "CustomerTableCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: cellTableIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 65
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segDidchange(_ segmented:UISegmentedControl){
        print(segmented.selectedSegmentIndex)
        requestData(sort: segmented.selectedSegmentIndex)
    }

    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

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
        let strURL = cellData.header_img_src
        if strURL == "" {
            cell.imgHeadIco.image = UIImage(named: "headsmall")
        } else {
            let icoURL = URL(string: strURL)
            cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        }
//        let icoURL = URL(string: cellData.header_img_src)
//        cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        cell.lblUserId.text = String.init(format: "ID:%d", cellData.id)
        cell.lblNickName.text = cellData.nick
        cell.lblCount.isHidden = true
        cell.lblTime.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = sourceData[indexPath.row]
        let vc = loadVCfromMain(identifier: "salesConfirmView") as! SalesConfirmView
        vc.buyer = cellData
        present(vc, animated: true, completion: nil)
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
                sourceData.append(CustomerTableCellModel(id: data["id"].intValue, nick: data["nick"].stringValue, header_img_src: data["header_img_src"].stringValue, customerType: data["customerType"].stringValue, cardNum: data["cardNum"].intValue, sellTime: data["sellTime"].stringValue))
            }
            tableView.reloadData()
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
