//
//  commentViewController.swift
//  XBook
//
//  Created by xlx on 16/1/8.
//  Copyright © 2016年 xlx. All rights reserved.
//

import UIKit

class commentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,InputViewDelegate{
    
    var tableView:UITableView?
    
    var dataArray = NSMutableArray()
    
    var BookObject:AVObject?
    
    var input:InputView?
    
    var layView:UIView?
    
    var keyBoardHeight:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let btn = self.view.viewWithTag(1234)
        btn?.isHidden = true
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 20,width: SCREEN_WIDTH,height: 44))
        titleLabel.text = "讨论区"
        titleLabel.font = UIFont(name: MY_FONT, size: 17)
        titleLabel.textAlignment = .center
        titleLabel.textColor = MAIN_RED
        self.view.addSubview(titleLabel)
        
        
        self.tableView = UITableView(frame: CGRect(x: 0,y: 64,width: SCREEN_WIDTH,height: SCREEN_HEIGHT - 64 - 44))
        self.tableView?.register(discussCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(commentViewController.headerRefresh))
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(commentViewController.footerRefresh))
        
        
        self.input = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.last as? InputView
        self.input?.frame = CGRect(x: 0,y: SCREEN_HEIGHT-44,width: SCREEN_WIDTH,height: 44)
        self.input?.delegate = self
        self.view.addSubview(self.input!)
        
        self.layView = UIView(frame: self.view.frame)
        self.layView?.backgroundColor = UIColor.gray
        self.layView?.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapLayView"))
        self.layView?.addGestureRecognizer(tap)
        self.view.insertSubview(self.layView!, belowSubview: self.input!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ok(){
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    /**
    *  UITableViewdelegate,UItableViewDataSource
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? discussCell
        cell?.initFrame()
        let object = self.dataArray[(indexPath as NSIndexPath).row] as? AVObject
        
        let user = object!["user"] as? AVUser
        cell?.nameLabel?.text = user?.username
        
        cell?.avatarImage?.image = UIImage(named: "Avatar")
        
        let date = object!["createdAt"] as? Date
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.dateLabel?.text = format.string(from: date!)
        
        cell?.detailLabel?.text = object!["text"] as? String
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = self.dataArray[(indexPath as NSIndexPath).row] as? AVObject
        let text = object!["text"] as? NSString
        let textSize = text?.boundingRect(with: CGSize(width: SCREEN_WIDTH-56-8,height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil).size
        
        return (textSize?.height)! + 30 + 25
    }
    /**
    *  上拉加载、下啦刷新
    */
    func headerRefresh(){
        let query = AVQuery(className: "discuss")
        query?.order(byDescending: "createdAt")
        query?.limit = 20
        query?.skip = 0
        query?.whereKey("user", equalTo: AVUser.current())
        query?.whereKey("BookObject", equalTo: self.BookObject)
        query?.includeKey("user")
        query?.includeKey("BookObject")
        query?.findObjectsInBackground { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjects(from: results!)
            self.tableView?.reloadData()
        }
    }
    func footerRefresh(){
        let query = AVQuery(className: "discuss")
        query?.order(byDescending: "createdAt")
        query?.limit = 20
        query?.skip = self.dataArray.count
        query?.whereKey("user", equalTo: AVUser.current())
        query?.whereKey("BookObject", equalTo: self.BookObject)
        query?.includeKey("user")
        query?.includeKey("BookObject")
        query?.findObjectsInBackground { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            self.dataArray.addObjects(from: results!)
            self.tableView?.reloadData()
        }
    }
    /**
    *  InputViewDelegate
    */
    func textViewHeightDidChange(_ height: CGFloat) {
        self.input?.height = height+10
        self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
    }
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
    func keyboardWillHide(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0
            self.input?.bottom = SCREEN_HEIGHT
            }) { (finish) -> Void in
                self.layView?.isHidden = true
                self.input?.resetInputView()
                self.input?.inputTextView?.text = ""
                self.input?.bottom = SCREEN_HEIGHT
        }
        
    }
    func keyboardWillShow(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        self.layView?.isHidden = false
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0
            self.input?.bottom = SCREEN_HEIGHT-keyboardHeight
            }) { (finish) -> Void in
                
        }
    }


}

















