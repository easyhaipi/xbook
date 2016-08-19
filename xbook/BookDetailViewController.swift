//
//  BookDetailViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/19.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController,BookTabBarDelegate,InputViewDelegate,HZPhotoBrowserDelegate {

    var BookObject:AVObject?
      var BookViewTabbar:BookTabBar?
     var BookTitleView:BookDetailView?
    
    var input:InputView?
    
    var layView:UIView?
    
    var keyBoardHeight:CGFloat = 0.0
    
    var BookTextView:UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        
        
        self.initBookDetailView()

        
        
        self.BookViewTabbar = BookTabBar(frame: CGRectMake(0,SCREEN_HEIGHT - 40,SCREEN_WIDTH,40))
        self.view.addSubview(self.BookViewTabbar!)
        self.BookViewTabbar?.delegate = self
        
        
        self.BookTextView = UITextView(frame: CGRectMake(0,64+SCREEN_HEIGHT/4,SCREEN_WIDTH,SCREEN_HEIGHT - 64 - SCREEN_HEIGHT/4-40))
        self.BookTextView?.editable = false
        self.BookTextView?.text = self.BookObject!["description"] as? String
        self.view.addSubview(self.BookTextView!)
         self.isLove()
        // Do any additional setup after loading the view.
    }
    
    
    
    /**
     是否点赞初始化
     
     */
    func isLove(){
        let query = AVQuery(className: "Love")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0{
                let btn = self.BookViewTabbar?.viewWithTag(2) as? UIButton
                btn?.setImage(UIImage(named: "solidheart"), forState: .Normal)
            }
            
        }
        
    }

    /**
     *  初始化BookDetailView
     */
    func initBookDetailView(){
        self.BookTitleView = BookDetailView(frame: CGRectMake(0,64,SCREEN_WIDTH  ,SCREEN_HEIGHT/4))
        self.view.addSubview(self.BookTitleView!)
        
        let coverFile = self.BookObject!["cover"] as? AVFile
        self.BookTitleView?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        self.BookTitleView?.BookName?.text = "《"+(self.BookObject!["BookName"] as! String) + "》"
        self.BookTitleView?.Editor?.text = "作者："+(self.BookObject!["BookEditor"] as! String)
        
        let user = self.BookObject!["user"] as? AVUser
        user?.fetchInBackgroundWithBlock({ (returnUser, error) -> Void in
            self.BookTitleView?.userName?.text = "编者："+(returnUser as! AVUser).username
        })
        
        let date = self.BookObject!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yy-MM-dd"
        self.BookTitleView?.date?.text = format.stringFromDate(date!)
        
        let scoreString = self.BookObject!["score"] as? String
        self.BookTitleView?.score?.show_star = Int(scoreString!)!
//        
        let scanNumber = self.BookObject!["scanNumber"] as? NSNumber
        let loveNumber = self.BookObject!["loveNumber"] as? NSNumber
        let discussNumber = self.BookObject!["discussNumber"] as? NSNumber
        
        self.BookTitleView?.more?.text = (loveNumber?.stringValue)!+"个喜欢."+(discussNumber?.stringValue)!+"次评论."+(scanNumber?.stringValue)!+"次浏览"
//
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookDetailViewController.photoBrowser as (BookDetailViewController) -> () -> ()))
        self.BookTitleView?.cover?.addGestureRecognizer(tap)
        self.BookTitleView?.cover?.userInteractionEnabled = true
        
        self.BookObject?.incrementKey("scanNumber")
        self.BookObject?.saveInBackground()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /**
     InputViewDelegate
     */
    func publishButtonDidClick(button: UIButton!) {
        ProgressHUD.show("")
        
        let object = AVObject(className: "discuss")
        object.setObject(self.input?.inputTextView?.text, forKey: "text")
        object.setObject(AVUser.currentUser(), forKey: "user")
        object.setObject(self.BookObject, forKey: "BookObject")
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.input?.inputTextView?.resignFirstResponder()
                ProgressHUD.showSuccess("评论成功")
                
                self.BookObject?.incrementKey("discussNumber")
                self.BookObject?.saveInBackground()
            }else{
                
            }
        }
    }
    func textViewHeightDidChange(height: CGFloat) {
        self.input?.height = height+10
        self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
    }
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.input?.bottom = SCREEN_HEIGHT+(self.input?.height)!
            self.layView?.alpha = 0
        }) { (finish) -> Void in
            
            self.layView?.hidden = true
            
        }
        
    }
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.input?.bottom = SCREEN_HEIGHT - keyboardHeight
            self.layView?.alpha = 0.2
        }) { (finish) -> Void in
            
        }
    }
    /**
     *  BookViewDelegate
     */
    func comment(){
        if self.input == nil {
            self.input = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as? InputView
            self.input?.frame = CGRectMake(0,SCREEN_HEIGHT-44,SCREEN_WIDTH,44)
            self.input?.delegate = self
            self.view.addSubview(self.input!)
        }
        if self.layView == nil {
            self.layView = UIView(frame: self.view.frame)
            self.layView?.backgroundColor = UIColor.grayColor()
            self.layView?.alpha = 0
            let tap = UITapGestureRecognizer(target: self, action: #selector(BookDetailViewController.tapInputView))
            self.layView?.addGestureRecognizer(tap)
            
        }
        self.view.insertSubview(self.layView!, belowSubview: self.input!)
        self.layView?.hidden = false
        self.input?.inputTextView?.becomeFirstResponder()
        
    }
    func tapInputView(){
        self.input?.inputTextView?.resignFirstResponder()
    }
    func commentController(){
        let vc = commentViewController()
        GeneralFactory.addTitleViewWithTitle(vc, title1: "", title2: "关闭")
        vc.BookObject = self.BookObject
        vc.tableView?.mj_header.beginRefreshing()
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        
    }
    func likeBook(btn:UIButton){
        btn.enabled = false
        btn.setImage(UIImage(named: "redheart"), forState: .Normal)
        
        let query = AVQuery(className: "Love")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0{///取消点赞
                for var object in results {
                    object = (object as? AVObject)!
                    object.deleteEventually()
                }
                btn.setImage(UIImage(named: "heart"), forState: .Normal)
                
                self.BookObject?.incrementKey("loveNumber", byAmount: NSNumber(int: -1))
                self.BookObject?.saveInBackground()
                
            }else{///点赞
                let object = AVObject(className: "Love")
                object.setObject(AVUser.currentUser(), forKey: "user")
                object.setObject(self.BookObject, forKey: "BookObject")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success{
                        btn.setImage(UIImage(named: "solidheart"), forState: .Normal)
                        
                        self.BookObject?.incrementKey("loveNumber", byAmount: NSNumber(int: 1))
                        self.BookObject?.saveInBackground()
                        
                    }else{
                        ProgressHUD.showError("操作失败")
                    }
                })
            }
            btn.enabled = true
            
        }
        
        
    }
    func shareAction(){
//        let shareParams = NSMutableDictionary()
//        shareParams.SSDKSetupShareParamsByText("分享内容", images: self.BookTitleView?.cover?.image, url: NSURL(string: "http://www.baidu.com"), title: "标题", type: SSDKContentType.Image)
        //        ShareSDK.share(.TypeWechat, parameters: shareParams) { (state, userData, contentEntity, error) -> Void in
        //            switch state{
        //            case SSDKResponseState.Success:
        //                ProgressHUD.showSuccess("分享成功")
        //                break
        //            case SSDKResponseState.Fail:
        //                ProgressHUD.showError("分享失败")
        //                break
        //            case SSDKResponseState.Cancel:
        //                ProgressHUD.showError("已取消分享")
        //                break
        //            default:
        //                break
        //            }
        //        }
        
//        ShareSDK.showShareActionSheet(self.view, items: [22], shareParams: shareParams) { (state, platForm, userdata, contentEntity, error, success) -> Void in
//            
//            switch state{
//            case SSDKResponseState.Success:
//                ProgressHUD.showSuccess("分享成功")
//                break
//            case SSDKResponseState.Fail:
//                ProgressHUD.showError("分享失败")
//                break
//            case SSDKResponseState.Cancel:
//                ProgressHUD.showError("已取消分享")
//                break
//            default:
//                break
//            }
//            
//        }
    }
    
    /**
     *  PhotoBrowser
     */
    func photoBrowser(){
        let photoBrowser = HZPhotoBrowser()
        photoBrowser.imageCount = 1
        photoBrowser.currentImageIndex = 0
        photoBrowser.delegate = self
        photoBrowser.show()
    }
    func photoBrowser(browser: HZPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        return self.BookTitleView?.cover?.image
    }
    func photoBrowser(browser: HZPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        let coverFile = self.BookObject!["cover"] as? AVFile
        return NSURL(string: coverFile!.url)
    }
    
}
