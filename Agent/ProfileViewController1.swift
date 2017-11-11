//
//  ProfileViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/11/2.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class ProfileViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tbView: UITableView!

    let profileItems = [
        ProfileCellModel(title: "昵称", content: "默认微信昵称", category: .section1),
        ProfileCellModel(title: "登录账号", content: "默认微信昵称", category: .section1),
        ProfileCellModel(title: "代理ID", content: "默认微信昵称", category: .section1),
        
        ProfileCellModel(title: "实名认证", content: "默认微信昵称", category: .section2),
        ProfileCellModel(title: "安全手机", content: "默认微信昵称", category: .section2),
        ProfileCellModel(title: "微信授权登录", content: "默认微信昵称", category: .section2),
        ProfileCellModel(title: "密码管理", content: "默认微信昵称", category: .section2),
        
        ProfileCellModel(title: "游戏", content: "默认微信昵称", category: .section3),
        ProfileCellModel(title: "服务城市", content: "默认微信昵称", category: .section3),
        ProfileCellModel(title: "开通时间", content: "默认微信昵称", category: .section3),
        ProfileCellModel(title: "代理特权", content: "默认微信昵称", category: .section3),
        
        ProfileCellModel(title: "关于", content: "默认微信昵称", category: .section4)
    ]
    
    var categoryItems = [Int:[ProfileCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbView!.delegate = self
        self.tbView!.dataSource = self
        self.tbView!.contentInset = UIEdgeInsetsMake(20, 5, 5, 20)
        // Do any additional setup after loading the view.
        for items in profileItems{
            if categoryItems[items.category.rawValue] == nil{
                categoryItems[items.category.rawValue] = [items]
            }else{
                categoryItems[items.category.rawValue]?.append(items)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categories = Array(categoryItems.keys)
        return categoryItems[categories[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        let categories = Array(categoryItems.keys)
        let items = categoryItems[categories[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = items.title
        return cell
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
