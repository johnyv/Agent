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
    
    let tools = [
        ["ico_club","俱乐部管理","这里是说明文案"],
        ["ico_match","比赛场管理","即将上线"],
        ["ico_bounus","积分商城","这里是说明文案"],
        ["ico_notice_list","公告列表","这里是说明文案"],
        ["ico_data_center","数据中心","这里是说明文案"],
        ["ico_agent_manager","下级代理管理","开通/禁用"]
    ]
    let cellToolIdentifier = "toolCell"
    
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var btnClub: UIButton!
    @IBOutlet weak var vTopBG: UIView!
    @IBOutlet weak var navMain: UINavigationItem!
    @IBOutlet weak var banner: BannerView!
    @IBOutlet weak var clvTools: UICollectionView!
    @IBOutlet weak var lblNotice: UILabel!
    
    var imgURLs = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])
        
        func handleNotice(json:JSON)->(){
            let result = json["result"]
            let code = result["code"].intValue
            if code == 200 {
                print(result)
            }
        }
        Network.request(.noticeScroll, success: handleNotice, provider: provider)

        func handleBanner(json:JSON)->(){
            let result = json["result"]
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

//        func handleAgreement(json:JSON)->(){
//            let result = json["result"]
//            let code = result["code"].intValue
//            if code == 200 {
//                print(result)
//            }
//        }
//        Network.request(.agreement, success: handleAgreement, provider: provider)

        //netProvider.request(.orderlist(year: "2017", month: "09", page: "1", type: "1")){ result in
        Network.request(.banner, success: handleBanner, provider: provider)
    }
    
    override func viewDidAppear(_ animated: Bool) {

//        Network.request(.banner){ result in
//            switch result{
//            case let .success(response):
//                let data = try? response.mapJSON()
//                let result = JSON(data!)
//            case let .failure(error):
//                break
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pushSalesView(_ sender: UIButton) {
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.mainNavi?.pushSalesView()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "salesView") as? SalesView
        present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func startPurshase(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "purchaseView") as? PurchaseView
        present(vc!, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellToolIdentifier, for: indexPath) as! ToolViewCell
        cell.imgIco.image = UIImage(named: tools[indexPath.item][0])
        cell.lblTitle.text = tools[indexPath.item][1]
        cell.lblDesc.text = tools[indexPath.item][2]
//        cell.imgIco.image = UIImage()
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
