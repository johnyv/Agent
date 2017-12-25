//
//  SoldToPlayerSearchResult.swift
//  Agent
//
//  Created by 于劲 on 2017/12/18.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class SoldToPlayerController: ButtonBarPagerTabStripViewController {
    
    var isReload = false
    
    var searchId:Int = 0
    var startDate:Int = 0
    var endDate:Int = 0

    override func viewDidLoad() {
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        settings.style.buttonBarItemTitleColor = UIColor.darkGray
        settings.style.buttonBarHeight = 35
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = .orange
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        super.viewDidLoad()
        
        let childView = viewControllers[currentIndex] as! CustomerDetail
        childView.delegate = childView.self
//        childView.reNew(type: currentIndex)
        childView.reNewByID(type: currentIndex, searchId: self.searchId, startDate: self.startDate, endDate: self.endDate)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let page1 = CustomerDetail(style: .plain, pageInfo: "最近售卡")
        let page2 = CustomerDetail(style: .plain, pageInfo: "售卡次数")
        let page3 = CustomerDetail(style: .plain, pageInfo: "售卡张数")
        
        guard isReload else {
            return [page1, page2, page3]
        }
        
        let childViews = [page1, page2, page3]
        return childViews
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let childView = viewControllers[currentIndex] as! CustomerDetail
        childView.delegate = childView.self
//        childView.reNew(type: currentIndex)
        childView.reNewByID(type: currentIndex, searchId: self.searchId, startDate: self.startDate, endDate: self.endDate)
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        let childView = viewControllers[currentIndex] as! CustomerDetail
        childView.delegate = childView.self
//        childView.reNew(type: currentIndex)
        childView.reNewByID(type: currentIndex, searchId: self.searchId, startDate: self.startDate, endDate: self.endDate)
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
    
    public func setCondition(searchId: Int, startDate: Int, endDate: Int) {
        self.searchId = searchId
        self.startDate = startDate
        self.endDate = endDate
    }
}

protocol SearchDelegate {
    func setCondition(searchId:Int, startDate: Int, endDate:Int, desc:String)
}

class SoldToPlayerSearchResult: UIViewController, SearchDelegate {

    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var searchId:Int?
    var startDate: Int?
    var endDate:Int?
    var desc:String = ""
    
    let cellTableIdentifier = "customerTableCell"
    var sourceData = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.title = "向玩家售卡明细"
        lblPeriod = addLabel(title: self.desc)
        lblPeriod.frame.size.width = 300
//        self.lblPeriod.text = self.desc
        let customerViewPage = SoldToPlayerController()
        customerViewPage.setCondition(searchId: self.searchId!, startDate: self.startDate!, endDate: self.endDate!)
        
        customerViewPage.view.frame.origin.y = lblPeriod.frame.origin.y + lblPeriod.frame.height
        addChildViewController(customerViewPage)
        view.addSubview(customerViewPage.view)

//        segSort.selectedSegmentIndex = 0
//        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        tableView.register(CustomerTableCell.self, forCellReuseIdentifier: cellTableIdentifier)
//        let xib = UINib(nibName: "CustomerTableCell", bundle: nil)
//        tableView.register(xib, forCellReuseIdentifier: cellTableIdentifier)
//        tableView.rowHeight = 65
//        tableView.tableFooterView = UIView()
//
//        request(.customerRecently(searchId: self.searchId!, startDate: self.startDate!, endDate: self.endDate!, sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
//
//        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func segDidchange(_ segmented:UISegmentedControl){
//        
//        switch segmented.selectedSegmentIndex {
//        case 0:
//            request(.customerRecently(searchId: self.searchId!, startDate: self.startDate!, endDate: self.endDate!, sortType: 0, pageIndex: 0, pageNum: 0), success: handleData)
//        case 1:
//            request(.customerTotallist(searchId: self.searchId!, startDate: self.startDate!, endDate: self.endDate!, sortType: 3, pageIndex: 0, pageNum: 0), success: handleData)
//        case 2:
//            request(.customerTotallist(searchId: self.searchId!, startDate: self.startDate!, endDate: self.endDate!, sortType: 2, pageIndex: 0, pageNum: 0), success: handleData)
//        default:
//            break
//        }
//    }

//    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }

    func setCondition(searchId: Int, startDate: Int, endDate: Int, desc:String) {
        self.searchId = searchId
        self.startDate = startDate
        self.endDate = endDate
        self.desc = desc
    }

//    func handleData(json:JSON)->(){
//        let result = json["result"]
//        let code = result["code"].intValue
//        if code == 200 {
//            print(result)
//            sourceData.removeAll()
//            let data = result["data"]
//            let dataArr = data["datas"].array
//            for(_, data) in (dataArr?.enumerated())!{
//                var cellData:[String:Any] = [:]
//                cellData["id"] =  data["id"].intValue
//                cellData["nick"] =  data["nick"].stringValue
//                cellData["header_img_src"] =  data["header_img_src"].stringValue
//                cellData["customerType"] =  data["customerType"].stringValue
//                cellData["cardNum"] =  data["cardNum"].intValue
//                cellData["sellTime"] =  data["sellTime"].stringValue
//                cellData["sellCount"] = data["sellCount"].intValue
//                sourceData.append(cellData)
//            }
////            if sourceData.count <= 0 {
////                self.view.makeToast("暂无数据", duration: 3, position: .top)
////            }
//            tableView.reloadData()
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension SoldToPlayerSearchResult: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sourceData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! CustomerTableCell
//        
//        // Configure the cell...
//        let cellData = sourceData[indexPath.row]
//        //        print(cellData.id)
//        //        print(cellData.nick)
//        //        cell.textLabel?.text = cellData.nick
//        cell.selectionStyle = .none
//        let strURL = cellData["header_img_src"] as! String
//        if strURL == "" {
//            cell.imgHeadIco.image = UIImage(named: "headsmall")
//        } else {
//            let icoURL = URL(string: strURL.convertToHttps())
//            cell.imgHeadIco.sd_setImage(with: icoURL, completed: nil)
//        }
//        cell.lblUserId.text = String.init(format: "ID:%d", cellData["id"] as! Int)
//        cell.lblNickName.text = cellData["nick"] as? String
//        cell.lblCount.text = String.init(format: "%d张", cellData["cardNum"] as! Int)
//        let sort = segSort.selectedSegmentIndex
//        if sort > 0 {
//            cell.lblTime.text = String.init(format: "%d次", cellData["sellCount"] as! Int)
//        } else {
//            cell.lblTime.text = cellData["sellTime"] as? String
//        }
//        return cell
//    }
//
//}
