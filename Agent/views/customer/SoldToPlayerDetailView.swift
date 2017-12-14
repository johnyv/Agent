//
//  SoldToPlayerDetailView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/14.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class SoldToPlayerDetailView: UIViewController {

    @IBOutlet weak var lblDataStart: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(selStartDate))
        lblDataStart.isUserInteractionEnabled = true
        lblDataStart.addGestureRecognizer(tap)
        
        let now = Date()
        let ft = DateFormatter()
        ft.dateFormat = "yyyy年MM月dd日"
        lblDataStart.text = ft.string(from: now)
        lblDateEnd.text = ft.string(from:now)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.lblDataStart.text = ft.string(from:datePicker.date)
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
