//
//  pushNewBookViewController.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class pushNewBookViewController: UIViewController,BookTitleDelegate,PhotoPickerDelegate,VPImageCropperDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var bookTitleView:BookTitleView?
    var tableView: UITableView?
    var titleArray:Array<String> = []
    var book_title = ""
    
    var score:LDXScore?
    
    
    var showScore = false
    
    
    
    
    override func viewDidLoad() {
        
       
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.bookTitleView = BookTitleView(frame:CGRectMake(0,40,SCREEN_WIDTH,160))
        self.bookTitleView?.delegate = self
        self.view.addSubview(self.bookTitleView!)
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - 200),style:.Grouped)
        
        self.tableView?.tableFooterView = UIView()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = UIColor(colorLiteralRed: 250/255,green:250/255,blue:250/255,alpha:1)
        
        
        self.view.addSubview(self.tableView!)
        
        
        self.titleArray = ["标题","评分","分类","书评"]
        
        
        self.score = LDXScore(frame:CGRectMake(100,10,100,22))
        self.score?.isSelect = true
        self.score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.score?.max_star = 5
        self.score?.show_star = 5
        
        showScore = false
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit{
        print("-PushNewVc---deinit")
    }
    
    func choiceCover() {
        print("------选择封面")
        
        
        
        let vc = PhotoPickerViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true) { 
            
        }
        
    }
    
    
    func getImageFromPicker(image: UIImage) {
        
        let Crovc = VPImageCropperViewController(image: image,cropFrame: CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH*1.273),limitScaleRatio:3)
        Crovc.delegate = self
        self.presentViewController(Crovc, animated: true) { 
            
        }
        
        
        
           }
    
    func close() {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    func ok() {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
   
    
    
    
    //裁剪控制器的代理方法
    
    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismissViewControllerAnimated(true) { 
            
        }
        
    }
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        self.bookTitleView?.BookCover?.setImage(editedImage, forState: .Normal)
        cropperViewController.dismissViewControllerAnimated(true) {
            
        }

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.Value1 ,reuseIdentifier: "cell")
//        let cell1 = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        for view in cell.contentView.subviews {
            view .removeFromSuperview()
        }
        
        
        if(indexPath.row != 1)
        {
            cell.accessoryType = .DisclosureIndicator
        }
        
        cell.textLabel?.text = self.titleArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: MY_FONT,size: 15)
        
        
        cell.detailTextLabel?.font = UIFont(name: MY_FONT,size: 13)

        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = self.book_title
            break
      
        default:
            
            break
        }
       
        if (self.showScore && indexPath.row == 2) {
            cell.contentView .addSubview(self.score!)
            
        }
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        var row = indexPath.row
        if (self.showScore && row>=2) {
            row -= 1
        }
        
        
        
        switch row {
        case 0://选择标题
            self.tableViewSelectTitle()
            break
        case 1://评分
           self.tableViewSelectScore()
            break
        case 2://分类
           self.tableViewSelectType()
            break
        case 3://书评
           self.tableViewSelectDescription()
            break
        default:
            
            break
        }

        
    }
    
    
    /**
     *选择标题
     */
    
    func tableViewSelectTitle()
    {
        let vc = Push_TitleViewController()
        GeneralFactory.addTitleViewWithTitle(vc)
        vc.callBack = ({(Title:String)->Void in
            self.book_title = Title
            self.tableView?.reloadData()
        });
  
        self.presentViewController(vc, animated: true) { 
            
        }
        
    }
    
    
    /**
     *选择评分
     */
    
    func tableViewSelectScore()
    {
       
        self.tableView?.beginUpdates()
        let temIndexPaths = [NSIndexPath(forRow:2,inSection: 0)]
        if self.showScore {
            self.titleArray.removeAtIndex(2)
            self.tableView?.deleteRowsAtIndexPaths(temIndexPaths, withRowAnimation: .Right)
            
            
             self.showScore = false
        }else{
            self.titleArray.insert("", atIndex: 2)
            self.tableView?.insertRowsAtIndexPaths(temIndexPaths, withRowAnimation: .Left)
            self.showScore = true
        }
        
       
        
        
        
        
        
        self.tableView?.endUpdates()
    }
    
    
    /**
     *选择分类
     */
    
    func tableViewSelectType()
    {
        let vc = Push_TypeViewController()
          GeneralFactory.addTitleViewWithTitle(vc)
        let btn1 = vc.view.viewWithTag(123) as?UIButton
        btn1?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        
        let btn2 = vc.view.viewWithTag(345) as?UIButton
        btn2?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        self.presentViewController(vc, animated: true) {
            
        }
    }
    
    
    /**
     *选择书评
     */
    
    func tableViewSelectDescription()
    {
        let vc = Push_DescriptionViewController()
          GeneralFactory.addTitleViewWithTitle(vc)
        self.presentViewController(vc, animated: true) {
            
        }
    }
    
    
    
    
    
    
    
}




