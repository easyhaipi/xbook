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
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default)
        
        
        self.initBookDetailView()

        
        
        self.BookViewTabbar = BookTabBar(frame: CGRect(x: 0,y: SCREEN_HEIGHT - 40,width: SCREEN_WIDTH,height: 40))
        self.view.addSubview(self.BookViewTabbar!)
        self.BookViewTabbar?.delegate = self
        
        
        self.BookTextView = UITextView(frame: CGRect(x: 0,y: 64+SCREEN_HEIGHT/4,width: SCREEN_WIDTH,height: SCREEN_HEIGHT - 64 - SCREEN_HEIGHT/4-40))
        self.BookTextView?.isEditable = false
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
        query?.whereKey("user", equalTo: AVUser.current())
        query?.whereKey("BookObject", equalTo: self.BookObject)
        query?.findObjectsInBackground { (results, error) -> Void in
            if results != nil && results?.count != 0{
                let btn = self.BookViewTabbar?.viewWithTag(2) as? UIButton
                btn?.setImage(UIImage(named: "solidheart"), for: UIControlState())
            }
            
        }
        
    }

    /**
     *  初始化BookDetailView
     */
    func initBookDetailView(){
        self.BookTitleView = BookDetailView(frame: CGRect(x: 0,y: 64,width: SCREEN_WIDTH  ,height: SCREEN_HEIGHT/4))
        self.view.addSubview(self.BookTitleView!)
        
        let coverFile = self.BookObject!["cover"] as? AVFile
        self.BookTitleView?.cover?.sd_setImage(with: URL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        self.BookTitleView?.BookName?.text = "《"+(self.BookObject!["BookName"] as! String) + "》"
        self.BookTitleView?.Editor?.text = "作者："+(self.BookObject!["BookEditor"] as! String)
        
        let user = self.BookObject!["user"] as? AVUser
        user?.fetchInBackground({ (returnUser, error) -> Void in
            self.BookTitleView?.userName?.text = "编者："+(returnUser as! AVUser).username
        })
        
        let date = self.BookObject!["createdAt"] as? Date
        let format = DateFormatter()
        format.dateFormat = "yy-MM-dd"
        self.BookTitleView?.date?.text = format.string(from: date!)
        
        let scoreString = self.BookObject!["score"] as? String
        self.BookTitleView?.score?.show_star = Int(scoreString!)!
//        
        let scanNumber = self.BookObject!["scanNumber"] as? NSNumber
        let loveNumber = self.BookObject!["loveNumber"] as? NSNumber
        let discussNumber = self.BookObject!["discussNumber"] as? NSNumber
        
        
        if loveNumber != nil && scanNumber != nil && discussNumber != nil{
            self.BookTitleView?.more?.text = (loveNumber?.stringValue)!+"个喜欢."+(discussNumber?.stringValue)!+"次评论."+(scanNumber?.stringValue)!+"次浏览"
            //
        }
        
     
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookDetailViewController.photoBrowser as (BookDetailViewController) -> () -> ()))
        self.BookTitleView?.cover?.addGestureRecognizer(tap)
        self.BookTitleView?.cover?.isUserInteractionEnabled = true
        
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
    func publishButtonDidClick(_ button: UIButton!) {
        ProgressHUD.show("")
        
        let object = AVObject(className: "discuss")
        object?.setObject(self.input?.inputTextView?.text, forKey: "text")
        object?.setObject(AVUser.current(), forKey: "user")
        object?.setObject(self.BookObject, forKey: "BookObject")
        object?.saveInBackground { (success, error) -> Void in
            if success {
                self.input?.inputTextView?.resignFirstResponder()
                ProgressHUD.showSuccess("评论成功")
                
                self.BookObject?.incrementKey("discussNumber")
                self.BookObject?.saveInBackground()
            }else{
                
            }
        }
    }
    func textViewHeightDidChange(_ height: CGFloat) {
        self.input?.height = height+10
        self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
    }
    func keyboardWillHide(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            self.input?.bottom = SCREEN_HEIGHT+(self.input?.height)!
            self.layView?.alpha = 0
        }) { (finish) -> Void in
            
            self.layView?.isHidden = true
            
        }
        
    }
    func keyboardWillShow(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
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
            self.input = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.last as? InputView
            self.input?.frame = CGRect(x: 0,y: SCREEN_HEIGHT-44,width: SCREEN_WIDTH,height: 44)
            self.input?.delegate = self
            self.view.addSubview(self.input!)
        }
        if self.layView == nil {
            self.layView = UIView(frame: self.view.frame)
            self.layView?.backgroundColor = UIColor.gray
            self.layView?.alpha = 0
            let tap = UITapGestureRecognizer(target: self, action: #selector(BookDetailViewController.tapInputView))
            self.layView?.addGestureRecognizer(tap)
            
        }
        self.view.insertSubview(self.layView!, belowSubview: self.input!)
        self.layView?.isHidden = false
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
        self.present(vc, animated: true) { () -> Void in
            
        }
        
    }
    func likeBook(_ btn:UIButton){
        btn.isEnabled = false
        btn.setImage(UIImage(named: "redheart"), for: UIControlState())
        
        let query = AVQuery(className: "Love")
        query?.whereKey("user", equalTo: AVUser.current())
        query?.whereKey("BookObject", equalTo: self.BookObject)
        query?.findObjectsInBackground { (results, error) -> Void in
            if results != nil && results?.count != 0{///取消点赞
                for var object in results! {
                    object = (object as? AVObject)!
                    (object as AnyObject).deleteEventually()
                }
                btn.setImage(UIImage(named: "heart"), for: UIControlState())
                
                self.BookObject?.incrementKey("loveNumber", byAmount: NSNumber(value: -1 as Int32))
                self.BookObject?.saveInBackground()
                
            }else{///点赞
                let object = AVObject(className: "Love")
                object?.setObject(AVUser.current(), forKey: "user")
                object?.setObject(self.BookObject, forKey: "BookObject")
                object?.saveInBackground({ (success, error) -> Void in
                    if success{
                        btn.setImage(UIImage(named: "solidheart"), for: UIControlState())
                        
                        self.BookObject?.incrementKey("loveNumber", byAmount: NSNumber(value: 1 as Int32))
                        self.BookObject?.saveInBackground()
                        
                    }else{
                        ProgressHUD.showError("操作失败")
                    }
                })
            }
            btn.isEnabled = true
            
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
    func photoBrowser(_ browser: HZPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return self.BookTitleView?.cover?.image
    }
    func photoBrowser(_ browser: HZPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        let coverFile = self.BookObject!["cover"] as? AVFile
        return URL(string: coverFile!.url)
    }
    
}
