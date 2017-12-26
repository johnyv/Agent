//
//  RoomCardViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/22.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import XLPagerTabStrip
import HooDatePicker

class CardsDetailPageController: ButtonBarPagerTabStripViewController {
    
    var isReload = false
    
    var time:Int = 0
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

        let childView = viewControllers[currentIndex] as! RoomCardsDetail
        childView.delegate = childView.self
        childView.reNew(type: currentIndex)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let page1 = RoomCardsDetail(style: .plain, pageInfo: "房卡支出")
        let page2 = RoomCardsDetail(style: .plain, pageInfo: "购卡明细")
        
        guard isReload else {
            return [page1, page2]
        }
        
        let childViews = [page1, page2]
        return childViews
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let childView = viewControllers[currentIndex] as! RoomCardsDetail
        childView.delegate = childView.self
        if time != 0 {
            childView.refreshDate(type: currentIndex, time: time)
        } else {
            childView.reNew(type: currentIndex)
        }
    }

    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        let childView = viewControllers[currentIndex] as! RoomCardsDetail
        childView.delegate = childView.self
        if time != 0 {
            childView.refreshDate(type: currentIndex, time: time)
        } else {
            childView.reNew(type: currentIndex)
        }
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
    
    public func setTime(time:Int){
        self.time = time
    }
}

class RoomCardViewController: UIViewController {

    @IBOutlet weak var lblSalesCount: UILabel!
    @IBOutlet weak var lblBuyCount: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
//    @IBOutlet weak var segSort: UISegmentedControl!
//    @IBOutlet weak var tbHeader1: UIView!
//    @IBOutlet weak var tbHeader2: UIView!
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vTopBg: UIView!
    
//    @IBOutlet weak var imgNoData: UIImageView!
//    @IBOutlet weak var lblNoData: UILabel!
    
    var lblMonth:UILabel!
    var month:Int!
    var lblSearch:UILabel!
    
    let cellTableIdentifier = "roomCardDetailCell"
    var sourceData = [CardDetailCellModel]()

    var cardsViewPage:CardsDetailPageController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vTopBg.backgroundColor = UIColor(hex: "008ce6")

        let rcBg = CGRect(x: 0, y: vTopBg.frame.origin.y + vTopBg.frame.height,
                          width: UIScreen.main.bounds.width, height: 30)
        let bg = UIView(frame: rcBg)
        bg.backgroundColor = UIColor(hex: "008cc6")
        view.addSubview(bg)
        let rcTitle = CGRect(x: 10, y: 0, width: 60, height: 30)
        lblMonth = UILabel(frame: rcTitle)
        lblMonth.textColor = .white
        bg.addSubview(lblMonth)
        lblMonth.text = "本月"
        lblMonth.font = UIFont.systemFont(ofSize: 14)
        
        lblSearch = UILabel(frame: rcTitle)
        lblSearch.frame.origin.x = bg.frame.width - lblSearch.frame.width - 20
        lblSearch.textAlignment = .right
        lblSearch.textColor = .white
        bg.addSubview(lblSearch)
        lblSearch.text = "搜索"
        lblSearch.font = UIFont.systemFont(ofSize: 14)

        let tapDate = UITapGestureRecognizer(target: self, action: #selector(selDate(_:)))
        lblSearch.isUserInteractionEnabled = true
        lblSearch.addGestureRecognizer(tapDate)

        cardsViewPage = CardsDetailPageController()
        cardsViewPage?.view.frame.origin.y = bg.frame.origin.y + bg.frame.height
        addChildViewController(cardsViewPage!)
        view.addSubview((cardsViewPage?.view)!)
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps:DateComponents = DateComponents()
        let date = Date()
        comps = calendar.dateComponents([.year, .month], from: date)
        month = comps.month

        let timeInterVal = Int(Date().timeIntervalSince1970*1000)

        request(.statisticAllNum(time: String(timeInterVal)), success: handleAllNum)
        requestBuyCount(time: String(timeInterVal))
        
        func handleInfo(json:JSON)->(){
            let result = json["result"]
            print(result)
            let code = result["code"].intValue
            if code == 200 {
                let data = result["data"]
                let cardCount:Int = data["cardCount"].intValue
                lblCurrent.text = String.init(format: "%d", cardCount)
            }
        }
        request(.myInfo, success: handleInfo)

        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selDate(_ recognizer:UITapGestureRecognizer){
        let datePicker = HooDatePicker(superView: self.view)
        datePicker?.delegate = self
        datePicker?.locale = Locale(identifier: "zh_CN")
        datePicker?.datePickerMode = HooDatePickerMode.yearAndMonth
        datePicker?.show()
    }
    
    func requestBuyCount(time:String){
        request(.goodDetailCollect(time: time), success: handleBuyCount)
    }
    
    func handleBuyCount(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let data = result["data"]
            lblBuyCount.text = data["goodCount"].stringValue
        }
    }

    func handleAllNum(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            lblSalesCount.text = result["data"].stringValue
        }
    }

    @IBAction func backToIndex(_ sender: UIBarButtonItem) {
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.menuTab?.selectedIndex = 0
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func service(_ sender: UIBarButtonItem) {
//        alertResult(code: 99)
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

extension RoomCardViewController: HooDatePickerDelegate {
    func datePicker(_ dataPicker: HooDatePicker!, didSelectedDate date: Date!) {
        let calender = Calendar(identifier: .gregorian)
        var comps:DateComponents = DateComponents()
        comps = calender.dateComponents([.year, .month], from: date)
        let month = comps.month
        
        if self.month == month {
            lblMonth.text = "本月"
        } else {
            lblMonth.text = String.init(format: "%d月", month!)
        }
        
        let idx = cardsViewPage?.currentIndex
        let vc = cardsViewPage?.viewControllers[idx!] as! RoomCardsDetail
        let time = Int(date.timeIntervalSince1970*1000)
        cardsViewPage?.setTime(time: time)
        vc.refreshDate(type: idx!, time: time)
    }
}
