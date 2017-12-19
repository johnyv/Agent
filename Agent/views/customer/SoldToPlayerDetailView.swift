//
//  SoldToPlayerDetailView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import HooDatePicker
import SwiftyJSON

class SoldToPlayerDetailView: UIViewController {

    @IBOutlet weak var lblDateBegin: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    @IBOutlet weak var tfSearchID: UITextField!
    
    @IBOutlet weak var btnSearch: UIButton!
    let ft = DateFormatter()
    
    var isBegin:Bool?
    var dateBegin:Int?
    var dateEnd:Int?
    
    var sourceData = [[String:Any]]()

    var searchDelegate:SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapDateBegin = UITapGestureRecognizer(target: self, action: #selector(selDate(_:)))
        lblDateBegin.isUserInteractionEnabled = true
        lblDateBegin.addGestureRecognizer(tapDateBegin)

        let tapDateEnd = UITapGestureRecognizer(target: self, action: #selector(selDate(_:)))
        lblDateEnd.isUserInteractionEnabled = true
        lblDateEnd.addGestureRecognizer(tapDateEnd)
        
        tfSearchID.keyboardType = .numberPad
        btnSearch.addTarget(self, action: #selector(doSearch(_:)), for: .touchUpInside)
        
        let now = Date()
        //let ft = DateFormatter()
        ft.dateFormat = "yyyy年MM月dd日"
        lblDateBegin.text = ft.string(from: now)
        lblDateEnd.text = ft.string(from:now)
        
        dateBegin = Int(now.timeIntervalSince1970*1000)
        dateEnd = Int(now.timeIntervalSince1970*1000)
        
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func selDate(_ recognizer:UITapGestureRecognizer){
        if recognizer.view == lblDateBegin {
            print("begin")
            isBegin = true
        }else if recognizer.view == lblDateEnd{
            print("end")
            isBegin = false
        }
        
        let datePicker = HooDatePicker(superView: self.view)
        datePicker?.delegate = self
        datePicker?.locale = Locale(identifier: "zh_CN")
        datePicker?.datePickerMode = HooDatePickerMode.date
        datePicker?.show()
    }

    func doSearch(_ sender: UIButton) {
        var id:Int?
        if tfSearchID.text != "" {
            id = Int(tfSearchID.text!)
        }else{
            id = 0
        }
        
        let desc = lblDateBegin.text!+"至"+lblDateEnd.text!
        print(desc)
        let vc = loadVCfromMain(identifier: "soldToPlayerSearchResult") as! SoldToPlayerSearchResult
        searchDelegate = vc.self
        searchDelegate?.setCondition(searchId: id!, startDate: self.dateBegin!, endDate: self.dateEnd!, desc:desc)
        
        present(vc, animated: true, completion: nil)
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
//            if sourceData.count <= 0 {
//                self.view.makeToast("暂无数据", duration: 3, position: .top)
//            }
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

extension SoldToPlayerDetailView: HooDatePickerDelegate {
    func datePicker(_ dataPicker: HooDatePicker!, didSelectedDate date: Date!) {
        if isBegin! {
            lblDateBegin.text = ft.string(from: date)
            dateBegin = Int(date.timeIntervalSince1970*1000)
        } else {
            lblDateEnd.text = ft.string(from: date)
            dateEnd = Int(date.timeIntervalSince1970*1000)
        }
    }
}
