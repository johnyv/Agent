//
//  PurchaseView.swift
//  Agent
//
//  Created by 于劲 on 2017/11/29.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
class PurchaseView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var goodsData = [PurchaseCellModel]()
    let cellGoodsIdentifier = "GoodsCell"
    @IBOutlet weak var clvGoods: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clvGoods.delegate = self
        clvGoods.dataSource = self
        
        let xib = UINib(nibName: "GoodsViewCell", bundle: nil)
        clvGoods.register(xib, forCellWithReuseIdentifier: cellGoodsIdentifier)
        
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])
        
        Network.request(.goodList, success: handleData, provider: provider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func listOrders(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersView") as? OrdersView
        present(vc!, animated: true, completion: nil)
    }
    
    fileprivate func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let dataArr = result["data"].array
            for(_, data) in (dataArr?.enumerated())!{
                goodsData.append(PurchaseCellModel(goodsId: data["goodsId"].stringValue, activityId: data["activityId"].intValue, cardNum: data["cardNum"].stringValue, extraNum: data["extraNum"].intValue, activityExtraNum: data["activityExtraNum"].intValue, price: data["price"].stringValue, superscript: data["superscript"].stringValue, desc: data["desc"].stringValue, createTime: data["createTime"].stringValue))
            }
            clvGoods.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGoodsIdentifier, for: indexPath) as! GoodsViewCell
        cell.lblCardNum.text = goodsData[indexPath.item].cardNum
        
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
