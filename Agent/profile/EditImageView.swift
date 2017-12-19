//
//  EditImageView.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditImageView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgHead: UIImageView!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgHead.isUserInteractionEnabled = true
        
        btnChoose.addTarget(self, action: #selector(self.doPickfromAlbum(_:)), for: .touchUpInside)
        btnCamera.addTarget(self, action: #selector(self.doPickfromCamera(_:)), for: .touchUpInside)
        
        btnChoose.setBorder(type: 1)
        btnCamera.setBorder(type: 0)
        
        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func doPickfromAlbum(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
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

        var image:UIImage!
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        imgHead.image = image
        
        
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/HI.png"
        
        func handleResult(json:JSON)->(){
            let result = json["result"]
            let code = result["code"].intValue
            print(result)
            if code == 200 {
                let newHI = result["data"].stringValue
                let hiURL = URL(string: newHI)
                imgHead.sd_setImage(with: hiURL, completed: nil)
            }else{
                toastMSG(result: result)
                //alertResult(code: code)
            }
        }

//        DispatchQueue.main.async(execute: { () -> Void in
            let imageData = UIImagePNGRepresentation(image)
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
