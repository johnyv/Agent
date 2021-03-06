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

class CustomerPageController: ButtonBarPagerTabStripViewController {
    
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
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        
        let childView = viewControllers[currentIndex] as! CustomerDetail
        childView.page = 0
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let childView = viewControllers[currentIndex] as! CustomerDetail
        childView.page = 0
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
    @IBOutlet weak var vTopBg: UIView!
    
    var customerViewPage:CustomerPageController!
    let cellTableIdentifier = "customerTableCell"
    var sourceData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vTopBg.backgroundColor = UIColor(hex: "008ce6")//kRGBColorFromHex(rgbValue: 0x008ce6)
        
        request(.customerAllNum(searchId: 0, startDate: 0, endDate: 0), success: handleAllnum)
//        requestData(sort: segSort.selectedSegmentIndex)

        customerViewPage = CustomerPageController()
        customerViewPage.view.frame.origin.y = vTopBg.frame.origin.y + vTopBg.frame.height
        customerViewPage.view.frame.size.height = view.bounds.height - vTopBg.frame.origin.y + vTopBg.frame.height - 164
        addChildViewController(customerViewPage)
        view.addSubview(customerViewPage.view)

        //autoFit()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(doRefresh(notifiction:)), name: notifyRefrsh, object: nil)
    }
    
    func handleAllnum(json:JSON)->(){
        let result = json["result"]
        print(result)
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
    
    func doRefresh(notifiction:NSNotification){
        
        let idx = customerViewPage?.currentIndex
        let childView = customerViewPage?.viewControllers[idx!] as! CustomerDetail
        childView.delegate = childView.self
        childView.reNew(type: idx!)

        request(.customerAllNum(searchId: 0, startDate: 0, endDate: 0), success: handleAllnum)
        
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func showDetail(_ sender: UIBarButtonItem) {
        let vc = SoldToPlayerDetailView()
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
