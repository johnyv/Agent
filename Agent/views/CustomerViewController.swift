//
//  CustomerViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip

class CustomerDetailController: ButtonBarPagerTabStripViewController {
    
    var isReload = false
    
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
        childView.reNew(type: currentIndex)
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        let childView = viewControllers[currentIndex] as! CustomerDetail
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
}

class CustomerViewController: UIViewController {
    
    @IBOutlet weak var sellPerson: UILabel!
    @IBOutlet weak var sellCount: UILabel!
//    @IBOutlet weak var segSort: UISegmentedControl!
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vTopBg: UIView!
    
//    @IBOutlet weak var imgNoData: UIImageView!
//    @IBOutlet weak var lblNoData: UILabel!
    let cellTableIdentifier = "customerTableCell"
    var sourceData = [[String:Any]]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vTopBg.backgroundColor = UIColor(hex: "008ce6")//kRGBColorFromHex(rgbValue: 0x008ce6)
        
        request(.customerAllNum(searchId: 0, startDate: 0, endDate: 0), success: handleAllnum)
//        requestData(sort: segSort.selectedSegmentIndex)

        let customerViewPage = CustomerDetailController()
        customerViewPage.view.frame.origin.y = vTopBg.frame.origin.y + vTopBg.frame.height
        addChildViewController(customerViewPage)
        view.addSubview(customerViewPage.view)

        autoFit()
    }
    
    func handleAllnum(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let data = result["data"]
            sellPerson.text = data["sellPerson"].stringValue
            sellCount.text = data["sellCount"].stringValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.count
    }
    
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func showDetail(_ sender: UIBarButtonItem) {
        let vc = loadVCfromMain(identifier: "soldToPlayerDetailView") as! SoldToPlayerDetailView
        self.navigationController?.pushViewController(vc, animated: true)
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
