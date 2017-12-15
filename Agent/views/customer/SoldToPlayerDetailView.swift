//
//  SoldToPlayerDetailView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import HooDatePicker

class SoldToPlayerDetailView: UIViewController {

    @IBOutlet weak var lblDateBegin: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    
    let ft = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(selDateBegin))
        lblDateBegin.isUserInteractionEnabled = true
        lblDateBegin.addGestureRecognizer(tap)
        
        let now = Date()
        //let ft = DateFormatter()
        ft.dateFormat = "yyyy年MM月dd日"
        lblDateBegin.text = ft.string(from: now)
        lblDateEnd.text = ft.string(from:now)
        
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selDateBegin(){
        let datePicker = HooDatePicker(superView: self.view)
        datePicker?.delegate = self
        datePicker?.locale = Locale(identifier: "zh_CN")
        datePicker?.datePickerMode = HooDatePickerMode.date
        datePicker?.show()
    }
    func selStartDate(){
        let datePickerAlert:UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        
        datePickerAlert.addAction(UIAlertAction(title: "确定", style: .default){
            (alertAction)->Void in
            print("date select: \(datePicker.date.description)")
            let ft = DateFormatter()
            ft.dateFormat = "yyyy年MM月dd日"
            //self.lblDataStart.text = ft.string(from:datePicker.date)
            //            let myDateButton=self.Datebutt as? DateButton
            //            myDateButton?.thedate=datePicker.date
            //            //强制刷新
            //            myDateButton?.setNeedsDisplay()
        })
        datePickerAlert.addAction(UIAlertAction(title: "取消", style: .cancel,handler:nil))
        datePickerAlert.view.addSubview(datePicker)
        present(datePickerAlert, animated: true, completion: nil)
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

extension SoldToPlayerDetailView: HooDatePickerDelegate {
    func datePicker(_ dataPicker: HooDatePicker!, didSelectedDate date: Date!) {
        lblDateBegin.text = ft.string(from: date)
    }
}
