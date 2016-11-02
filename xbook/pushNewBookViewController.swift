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
    
    
    var type = "文学"
    var detailType = "文学"
    
    var des_description = ""
    
    
    
    /// 编辑
    var BookObject:AVObject?
    var fixType:String?
    
    
    override func viewDidLoad() {
        
       
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.bookTitleView = BookTitleView(frame:CGRect(x: 0,y: 40,width: SCREEN_WIDTH,height: 160))
        self.bookTitleView?.delegate = self
        self.view.addSubview(self.bookTitleView!)
        
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 200, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 200),style:.grouped)
        
        self.tableView?.tableFooterView = UIView()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        
        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = UIColor(colorLiteralRed: 250/255,green:250/255,blue:250/255,alpha:1)
        
        
        self.view.addSubview(self.tableView!)
        
        
        self.titleArray = ["标题","评分","分类","书评"]
        
        
        self.score = LDXScore(frame:CGRect(x: 100,y: 10,width: 100,height: 22))
        self.score?.isSelect = true
        self.score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.score?.max_star = 5
        self.score?.show_star = 5
        
        showScore = false
        
        
        /**
         注册通知
         */
        NotificationCenter.default.addObserver(self, selector: #selector(pushNewBookViewController.pushCallBack(_:)), name: NSNotification.Name(rawValue: "pushCallBack"), object: nil)
    }
    
    
    /**
     编辑
     */
    func fixBook(){
        if self.fixType == "fix" {
            self.bookTitleView?.BookName?.text = self.BookObject!["BookName"] as? String
            self.bookTitleView?.BookEditor?.text = self.BookObject!["BookEditor"] as? String
            let coverFile = self.BookObject!["cover"] as? AVFile
            coverFile?.getDataInBackground({ (data, error) -> Void in
                self.bookTitleView?.BookCover?.setImage(UIImage(data: data!), for: UIControlState())
            })
            
            self.book_title = (self.BookObject!["title"] as? String)!
            self.type = (self.BookObject!["type"] as? String)!
            self.detailType = (self.BookObject!["detailType"] as? String)!
            self.des_description = (self.BookObject!["description"] as? String)!
            self.score?.show_star = (Int)((self.BookObject!["score"] as? String)!)!
            if self.des_description != "" {
                self.titleArray.append("")
            }
        }
    }

    
    /**
     pushCallBack
     */
    func pushCallBack(_ notification:Notification){
        let dict = (notification as NSNotification).userInfo
        if (String(describing: dict!["success"]!)) == "true" {
          
            if self.fixType == "fix" {
                
                ProgressHUD.showSuccess("修改成功")
            }else{
                
                ProgressHUD.showSuccess("上传成功")
            }
        
            
            self.dismiss(animated: true, completion: { () -> Void in
                
            })
        }else{
            ProgressHUD.showError("上传失败")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit{
        print("pushNewBookController reallse")
        /**
         移除通知
         */
        NotificationCenter.default.removeObserver(self)
    }
    func choiceCover() {
        print("------选择封面")
        
        
        
        let vc = PhotoPickerViewController()
        vc.delegate = self
        self.present(vc, animated: true) { 
            
        }
        
    }
    
    
    func getImageFromPicker(_ image: UIImage) {
        
        let Crovc = VPImageCropperViewController(image: image,cropFrame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: SCREEN_WIDTH*1.273),limitScaleRatio:3)
        Crovc?.delegate = self
        self.present(Crovc!, animated: true) { 
            
        }
        
        
        
           }
    
    func close() {
        self.dismiss(animated: true) { 
            
        }
    }
    func ok() {
        
        let dict = [
            "BookName":(self.bookTitleView?.BookName?.text)!,
            "BookEditor":(self.bookTitleView?.BookEditor?.text)!,
            "BookCover":(self.bookTitleView?.BookCover?.currentImage)!,
            "title":self.book_title,
            "score":String((self.score?.show_star)!),
            "type":self.type,
            "detailType":self.detailType,
            "description":self.des_description,
            ] as [String : Any]
            ProgressHUD.show("")
        
      
        if self.fixType == "fix" {
            pushBook.pushBookInBack(dict as NSDictionary, object: self.BookObject!)
        }else{
            
            let object = AVObject(className: "Book")
            pushBook.pushBookInBack(dict as NSDictionary, object: object!)
        }

       

        self.dismiss(animated: true) {
            
        }
    }
   
    
    
    
    //裁剪控制器的代理方法
    
    func imageCropperDidCancel(_ cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismiss(animated: true) { 
            
        }
        
    }
    func imageCropper(_ cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        self.bookTitleView?.BookCover?.setImage(editedImage, for: UIControlState())
        cropperViewController.dismiss(animated: true) {
            
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.value1 ,reuseIdentifier: "cell")
//        let cell1 = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        for view in cell.contentView.subviews {
            view .removeFromSuperview()
        }
        
        
        if((indexPath as NSIndexPath).row != 1)
        {
            cell.accessoryType = .disclosureIndicator
        }
        
        cell.textLabel?.text = self.titleArray[(indexPath as NSIndexPath).row]
        cell.textLabel?.font = UIFont(name: MY_FONT,size: 15)
        
        
        cell.detailTextLabel?.font = UIFont(name: MY_FONT,size: 13)

        
        var row = (indexPath as NSIndexPath).row
        if (self.showScore && row>=2) {
            row -= 1
        }
        
        switch row {
        case 0:
            cell.detailTextLabel?.text = self.book_title
            break
        case 2:
            cell.detailTextLabel?.text = self.type + "-->" + self.detailType
            break
    
        case 4:
            cell.accessoryType = .none
            let commentView = UITextView(frame: CGRect(x: 4,y: 4, width: SCREEN_WIDTH-8, height: 80))
            
            commentView.text = self.des_description
            commentView.font = UIFont(name: MY_FONT,size: 13)
            commentView.isEditable = false
            cell.contentView.addSubview(commentView)
            break
        default:
            break
        }
       
        if (self.showScore && (indexPath as NSIndexPath).row == 2) {
            cell.contentView .addSubview(self.score!)
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
            if showScore && (indexPath as NSIndexPath).row >= 5 {
                return 88
            }else if  !showScore && (indexPath as NSIndexPath).row >= 4 {
                
                return  88
            } else{
             return   44
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        var row = (indexPath as NSIndexPath).row
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
  
        self.present(vc, animated: true) { 
            
        }
        
    }
    
    
    /**
     *选择评分
     */
    
    func tableViewSelectScore()
    {
       
        self.tableView?.beginUpdates()
        let temIndexPaths = [IndexPath(row:2,section: 0)]
        if self.showScore {
            self.titleArray.remove(at: 2)
            self.tableView?.deleteRows(at: temIndexPaths, with: .right)
            
            
             self.showScore = false
        }else{
            self.titleArray.insert("", at: 2)
            self.tableView?.insertRows(at: temIndexPaths, with: .left)
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
        btn1?.setTitleColor(RGB(38, g: 82, b: 67), for: UIControlState())
        
        let btn2 = vc.view.viewWithTag(345) as?UIButton
        btn2?.setTitleColor(RGB(38, g: 82, b: 67), for: UIControlState())
        vc.type = self.type
        vc.detailType = self.detailType
        vc.callBlock = ({(type:String,detailType:String)->Void in
            self.type = type
            self.detailType = detailType
            self.tableView?.reloadData()
        
        });
        self.present(vc, animated: true) {
            
        }
    }
    
    
    /**
     *选择书评
     */
    
    func tableViewSelectDescription()
    {
        let vc = Push_DescriptionViewController()
          GeneralFactory.addTitleViewWithTitle(vc)
       vc.textView?.text = self.des_description
        vc.callBlock = ({(des:String)->Void in
            self.des_description = des
           
            if self.titleArray.last == "" {
                self.titleArray.removeLast()
            }
            if self.des_description != "" {
                self.titleArray .append("")
            }
             self.tableView?.reloadData()
        });
        

        self.present(vc, animated: true) {
            
        }
    }
    
    
    
    
    
    
    
}




