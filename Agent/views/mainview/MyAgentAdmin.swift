//
//  MyAgentAdmin.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyAgentAdmin: UIViewController {

    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!

    @IBOutlet weak var segSort: UISegmentedControl!
    
    var sourceData = [MyAgentCellModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segSort.selectedSegmentIndex = 0
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
        
        btnOpen.addTarget(self, action: #selector(toOpen(_:)), for: .touchUpInside)
        request(.myagent(agentType: segSort.selectedSegmentIndex, page: 1, pageSize: 0), success: handleData)
    }

    override func viewDidAppear(_ animated: Bool) {
        let count = sourceData.count
        showNodata(dataCount: count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func toOpen(_ button:UIButton){
        let payVC = loadVCfromMain(identifier: "myAgentToOpen") as! MyAgentToOpen
        present(payVC, animated: true, completion: nil)
    }

    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            //            sourceData.removeAll()
            print(result)
            let data = result["data"]
            let dataArr = data["myAgentList"].array
            for(_, data) in (dataArr?.enumerated())!{
                //data["id"].intValue,data["createTime"].stringValue,data["title"].stringValue
//                sourceData.append([NoticeListCellModel(id: data["id"].intValue, title: data["title"].stringValue, createTime: data["createTime"].stringValue)])
            }
            tableView.reloadData()
            let count = sourceData.count
            showNodata(dataCount: count)
        }
    }
    
    func segDidchange(_ segmented:UISegmentedControl){
        print(segmented.selectedSegmentIndex)
        request(.myagent(agentType: segSort.selectedSegmentIndex, page: 1, pageSize: 0), success: handleData)
    }

    func showNodata(dataCount:Int){
        if dataCount > 0 {
            imgNoData.isHidden = true
            lblNoData.isHidden = true
            btnOpen.isHidden = true
            tableView.isHidden = false
        }else{
            imgNoData.isHidden = false
            lblNoData.isHidden = false
            btnOpen.isHidden = false
            tableView.isHidden = true
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
