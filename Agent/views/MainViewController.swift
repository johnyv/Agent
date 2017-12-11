//
//  MainViewController.swift
//  Agent
//
//  Created by 于劲 on 2017/10/26.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import SDWebImage

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    let tools = [
//        ["ico_club","俱乐部管理","这里是说明文案"],
//        ["ico_match","比赛场管理","即将上线"],
//        ["ico_bounus","积分商城","这里是说明文案"],
//        ["ico_notice_list","公告列表","这里是说明文案"],
//        ["ico_data_center","数据中心","这里是说明文案"],
//        ["ico_agent_manager","下级代理管理","开通/禁用"]
//    ]
    let cellToolIdentifier = "toolCell"
    
    @IBOutlet weak var navMain: UINavigationBar!
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var btnClub: UIButton!
    @IBOutlet weak var vTopBG: UIView!
    @IBOutlet weak var banner: BannerView!
    @IBOutlet weak var clvTools: UICollectionView!
    @IBOutlet weak var lblNotice: UILabel!
    
    var imgURLs = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let agent = getAgent()
        let gameName = agent["gameName"] as? String

//        let gameName = UserDefaults.standard.string(forKey: "gameName")
        self.navigationItem.title = gameName
        btnSale.setTitleAlign(position: .bottom)
        btnPurchase.setTitleAlign(position: .bottom)
        btnClub.setTitleAlign(position: .bottom)
        
        clvTools.delegate = self
        clvTools.dataSource = self
        let xib = UINib(nibName: "ToolViewCell", bundle: nil)
        clvTools.register(xib, forCellWithReuseIdentifier: cellToolIdentifier)
        //clvTools.backgroundColor = UIColor.white
        //clvTools.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        vTopBG.backgroundColor = kRGBColorFromHex(rgbValue: 0x008ce6)
//        vTopBG.snp.makeConstraints({(make) -> Void in
//            make.top.equalTo(450)
//            make.width.equalTo(self.view)
//            make.centerX.equalTo(self.view)})
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[AuthPlugin(tokenClosure: {return source.token})])
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
        request(.noticeScroll, success: handleNotice)
        request(.banner, success: handleBanner)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pushSalesView(_ sender: UIButton) {
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.mainNavi?.pushSalesView()
        
        let vc = loadVCfromMain(identifier: "salesView") as? SalesView
        present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func startPurshase(_ sender: UIButton) {
        let vc = loadVCfromMain(identifier: "purchaseView") as? PurchaseView
        present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func startClub(_ sender: UIButton) {
        alertResult(code: 99)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tools = authorityList.getToolsByAuthority()
        return tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellToolIdentifier, for: indexPath) as! ToolViewCell
        let tools = authorityList.getToolsByAuthority()
        
        cell.imgIco.image = UIImage(named: tools[indexPath.item][0])
        cell.lblTitle.text = tools[indexPath.item][1]
        cell.lblDesc.text = tools[indexPath.item][2]
//        cell.imgIco.image = UIImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tools = authorityList.getToolsByAuthority()
        let itemName = tools[indexPath.item][0]
        switch itemName {
        case "ico_agent_manager":
            let vc = loadVCfromMain(identifier: "myAgentAdmin") as! MyAgentAdmin
            present(vc, animated: true, completion: nil)
        case "ico_notice_list":
            let vc = loadVCfromMain(identifier: "noticeListView") as! NoticeListView
            present(vc, animated: true, completion: nil)

        default:
            alertResult(code: 99)
        }
    }
    
    func handleNotice(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            let data = result["data"]
            let title = data["title"].stringValue
            lblNotice.text = title
        }
    }
    
    func handleBanner(json:JSON)->(){
        let result = json["result"]
        print(result)
        let code = result["code"].intValue
        if code == 200 {
            let dataArr = result["data"].array
            if(dataArr == nil){
                return
            }
            for(_, data) in (dataArr?.enumerated())!{
                imgURLs.append(data["imageUrl"].stringValue as AnyObject)
            }
            banner.imageURLs = imgURLs
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
