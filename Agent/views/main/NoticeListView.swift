//
//  NoticeListView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/11.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeListView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let cellTableIdentifier = "commonCell"
    var sourceData = [[NoticeListCellModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellTableIdentifier)
        tableView.tableFooterView = UIView()
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.systemFont(ofSize: 10.0)
        request(.noticeList(page: 1, pageSize: 0), success: handleData)
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sourceData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = sourceData[section]
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = sourceData[section]
        return data[0].createTime
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let data = sourceData[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.textLabel?.text = data.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = loadVCfromMain(identifier: "noticeDetailView") as! NoticeDetailView
        let selectCellData = sourceData[indexPath.section][indexPath.row]
        vc.noticeId = selectCellData.id
        present(vc, animated: true, completion: nil)
    }
    
    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
//            sourceData.removeAll()
            print(result)
            let data = result["data"]
            let dataArr = data["noticeList"].array
            for(_, data) in (dataArr?.enumerated())!{
                //data["id"].intValue,data["createTime"].stringValue,data["title"].stringValue
                sourceData.append([NoticeListCellModel(id: data["id"].intValue, title: data["title"].stringValue, createTime: data["createTime"].stringValue)])
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
