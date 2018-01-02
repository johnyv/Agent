//
//  MyAgentAdmin.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip

protocol PageRefreshDelegate {
    func refresh()
}

class AgentViewPageController: ButtonBarPagerTabStripViewController {
    
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
        
        let childView = viewControllers[currentIndex] as! MyAgentList
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let page1 = MyAgentList(style: .plain, pageInfo: "全部代理")
        let page2 = MyAgentList(style: .plain, pageInfo: "VIP代理")
        let page3 = MyAgentList(style: .plain, pageInfo: "普通代理")
        
        guard isReload else {
            return [page1, page2, page3]
        }
        
        let childViews = [page1, page2, page3]
        return childViews
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        
        let childView = viewControllers[currentIndex] as! MyAgentList
        childView.page = 0
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let childView = viewControllers[currentIndex] as! MyAgentList
        childView.page = 0
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
}

extension AgentViewPageController: PageRefreshDelegate {
    func refresh() {
        let childView = viewControllers[currentIndex] as! MyAgentList
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
}

class MyAgentAdmin: UIViewController {

    var agentViewPage:AgentViewPageController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.title = "我的代理"

        agentViewPage = AgentViewPageController()
        addChildViewController(agentViewPage)
        view.addSubview(agentViewPage.view)

        let rightButton = UIBarButtonItem(title: "开通代理", style: .plain, target: self, action: #selector(newAgent(_:)))
        self.navigationItem.rightBarButtonItem = rightButton

//        btnNew = addButton(title: "立即开通", action: #selector(newAgent(_:)))
//        btnNew.frame.origin.y = UIScreen.main.bounds.height - btnNew.frame.height - 100
//        btnNew.setBorder(type: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func newAgent(_ button:Any){
        let vc = MyAgentNew()
        vc.pageDelegate = agentViewPage.self
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
