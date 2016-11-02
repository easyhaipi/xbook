//
//  PhotoPickerViewController.swift
//  xbook
//
//  Created by taobaichi on 16/7/1.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit


protocol PhotoPickerDelegate{
    func getImageFromPicker(_ image:UIImage)
}



class PhotoPickerViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    
    var alert:UIAlertController?
    var picker:UIImagePickerController!
    var delegate:PhotoPickerDelegate?
    
    
    init(){
        super.init(nibName:nil,bundle:nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor.clear
        
        
        self.picker = UIImagePickerController()
        self.picker.allowsEditing = false//自己来做截图
        self.picker.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if(self.alert == nil)
        {
            self.alert = UIAlertController(title: nil,message: nil,preferredStyle: .actionSheet)
        
            self.alert?.addAction(UIAlertAction(title: "从相册选择",style: .default,handler: {(action) -> Void in
               self.localPhoto()
            
            }))
            self.alert?.addAction(UIAlertAction(title: "打开相机",style: .default,handler: {(action) -> Void in
                self.takePhoto()
                
            }))
            self.alert?.addAction(UIAlertAction(title: "取消",style: .cancel,handler: {(action) -> Void in
                
                
            }))
            
            
            self.present(self.alert!, animated: true, completion: { 
                
            })
        }
    }
  
    
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {//有照相机
            
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: {
                
            })

            
        }else{
            
          let  alertView  = UIAlertController(title: "此机型无相机",message: nil,preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "关闭",style: .cancel,handler: {(action) -> Void in
                
                self.dismiss(animated: true, completion: { 
                    
                })
            }))
            self.present(alertView, animated: true, completion: { 
             
            })
        }
        
    }
    
    func localPhoto() {
        self.picker.sourceType = .photoLibrary

        self.present(self.picker, animated: true, completion: {
            
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true) { 
            self.dismiss(animated: true, completion: { 
                
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
      
        self.picker.dismiss(animated: true) {
            self.dismiss(animated: true, completion: { 
                 self.delegate?.getImageFromPicker(image)
            })
        }

    }
}
