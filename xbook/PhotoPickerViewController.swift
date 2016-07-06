//
//  PhotoPickerViewController.swift
//  xbook
//
//  Created by taobaichi on 16/7/1.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit


protocol PhotoPickerDelegate{
    func getImageFromPicker(image:UIImage)
}



class PhotoPickerViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    
    var alert:UIAlertController?
    var picker:UIImagePickerController!
    var delegate:PhotoPickerDelegate?
    
    
    init(){
        super.init(nibName:nil,bundle:nil)
        
        self.modalPresentationStyle = .OverFullScreen
        self.view.backgroundColor = UIColor.clearColor()
        
        
        self.picker = UIImagePickerController()
        self.picker.allowsEditing = false
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
    

    override func viewDidAppear(animated: Bool) {
        if(self.alert == nil)
        {
            self.alert = UIAlertController(title: nil,message: nil,preferredStyle: .ActionSheet)
        
            self.alert?.addAction(UIAlertAction(title: "从相册选择",style: .Default,handler: {(action) -> Void in
               self.localPhoto()
            
            }))
            self.alert?.addAction(UIAlertAction(title: "打开相机",style: .Default,handler: {(action) -> Void in
                self.takePhoto()
                
            }))
            self.alert?.addAction(UIAlertAction(title: "取消",style: .Cancel,handler: {(action) -> Void in
                
                
            }))
            
            
            self.presentViewController(self.alert!, animated: true, completion: { 
                
            })
        }
    }
  
    
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {//有照相机
            
            self.picker.sourceType = .Camera
            self.presentViewController(self.picker, animated: true, completion: {
                
            })

            
        }else{
            
          let  alertView  = UIAlertController(title: "此机型无相机",message: nil,preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "关闭",style: .Cancel,handler: {(action) -> Void in
                
                
            }))
            self.presentViewController(alertView, animated: true, completion: { 
                
            })
        }
        
    }
    
    func localPhoto() {
        self.picker.sourceType = .PhotoLibrary
        
        
        
        self.presentViewController(self.picker, animated: true, completion: {
            
        })
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
       self.delegate?.getImageFromPicker(image)
        self.picker.dismissViewControllerAnimated(true) {
            
        }

    }
}
