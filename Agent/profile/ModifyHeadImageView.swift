//
//  EditImageView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage


class ModifyHeadImageView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegateModify:ModifyProfileDelegage?

    @IBOutlet weak var imgHead: UIImageView!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        self.title = "编辑头像"
        
        imgHead = addImageView()

        let profile = getProfile()
        let strURL = profile["headerImgSrc"] as? String
        if strURL != "" {
            let imgURL = URL(string: strURL!)
            imgHead.sd_setImage(with: imgURL, completed: nil)
        } else {
            imgHead.image = UIImage(named: "headbig")
        }
        
        let size:CGFloat = 235
        let rcImgHead = CGRect(x: (UIScreen.main.bounds.width - size) / 2 , y: 65, width: size, height: size)
        imgHead.frame = rcImgHead
        
        btnChoose = addButton(title: "从相册选一张", action: #selector(self.doPickfromAlbum(_:)))
        let buttonWidth:CGFloat = 325
        let buttonCenter:CGFloat = (UIScreen.main.bounds.width - buttonWidth) / 2
        
        btnChoose.frame = CGRect(x: buttonCenter, y: imgHead.frame.origin.y + imgHead.frame.height + 50, width: buttonWidth, height: 41)

        btnCamera = addButton(title: "拍一张照片", action: #selector(self.doPickfromCamera(_:)))
        btnCamera.frame = CGRect(x: buttonCenter, y: btnChoose.frame.origin.y + btnChoose.frame.height + 30, width: buttonWidth, height: 41)
        
        btnChoose.setBorder(type: 0)
        btnCamera.setBorder(type: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doPickfromAlbum(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
    
    func doPickfromCamera(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            if UIImagePickerController.isCameraDeviceAvailable(.front){
                picker.cameraDevice = .front
            }
            picker.delegate = self
            picker.cameraFlashMode = .auto
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }else{
            print("找不到相机")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        let image:UIImage!
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        imgHead.image = image
        
        
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/HI.png"
        
        func handleHI(json:JSON)->(){
            let result = json["result"]
            print(result)
            let code = result["code"].intValue
            if code == 200 {
                delegateModify?.refresh()
                dismiss(animated: true, completion: nil)
                
            } else {
                toastMSG(result: result)
            }
        }
        
        func handleResult(json:JSON)->(){
            let result = json["result"]
            let code = result["code"].intValue
            print(result)
            if code == 200 {
                let newHI = result["data"].stringValue.convertToHttps()
                let hiURL = URL(string: newHI!)
                imgHead.sd_setImage(with: hiURL, completed: {(image, error, cacheType, url) in
                })
                request(.editHI(headerImgSrc: newHI!), success: handleHI)
            }else{
                toastMSG(result: result)
            }
        }

//        DispatchQueue.main.async(execute: { () -> Void in
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)

            if fileManager.fileExists(atPath: filePath) {
                let fileURL = URL(fileURLWithPath: filePath)
                let fileData = try! Data(contentsOf: fileURL)
                request(.upload(file: fileData), success: handleResult)
            }
//        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

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
