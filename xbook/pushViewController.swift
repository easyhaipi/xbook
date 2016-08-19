//
//  pushViewController.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class pushViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate{

    
    
    var dataArray = NSMutableArray()
     var navigationView:UIView!
    var tableView:UITableView?
    
    var swipIndexPath:NSIndexPath?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.view.backgroundColor = UIColor.whiteColor()
    self.setNavigationBar()
        
        
        
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.registerClass(Push_BookCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.tableFooterView = UIView()
        
        
        
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget:self,refreshingAction:#selector(pushViewController.HeaderRefreshMore))
        self.tableView?.mj_footer = MJRefreshBackFooter(refreshingTarget:self,refreshingAction:#selector(pushViewController.FooterRefreshMore))
        
        
        
      self.tableView?.mj_header.beginRefreshing()
    
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationView.hidden = false
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationView.hidden = true
    }
    
    func HeaderRefreshMore(){
        
        let query = AVQuery(className: "Book")
        query.orderByDescending("createdAt")
        
        query.limit = 20
        query.skip = 0
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) in
            self.tableView?.mj_header.endRefreshing()
            
    
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
            
            
        }
        
    }
    func FooterRefreshMore(){
        let query = AVQuery(className: "Book")
        query.orderByDescending("createdAt")
        
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) in
            self.tableView?.mj_footer.endRefreshing()
            
            
         
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setNavigationBar(){
        navigationView = UIView(frame: CGRectMake(0,-20,SCREEN_WIDTH,65))
        navigationView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.addSubview(navigationView)
        
        
        let addBookButton = UIButton(frame:CGRectMake(20,20,SCREEN_WIDTH,45))
        addBookButton.setImage(UIImage(named: "plus circle"), forState: .Normal)
        addBookButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addBookButton.setTitle("     新建书评", forState: .Normal)
        addBookButton.titleLabel?.font = UIFont(name:MY_FONT,size: 15)
        addBookButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        addBookButton.addTarget(self, action:#selector(pushViewController.pushNewBookAction), forControlEvents: .TouchUpInside)
        
        
        navigationView .addSubview(addBookButton)
        
    }
    
    
    func pushNewBookAction(){
      
        
        
        let vc = pushNewBookViewController()
        GeneralFactory.addTitleViewWithTitle(vc)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as?Push_BookCell
        
        cell?.rightUtilityButtons = self.returnRightButtons()
        cell?.delegate = self
        
        
        let dict = self.dataArray[indexPath.row] as?AVObject
        
        cell?.BookName?.text = "《"+(dict!["BookName"] as! String)+"》:"+(dict!["title"] as! String)
        cell?.Editor?.text = "作者:"+(dict!["BookEditor"] as! String)
        
        let date = dict!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.more?.text = format.stringFromDate(date!)
        
        let coverFile = dict!["cover"] as? AVFile
        cell?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        return cell!
    }
    
    
    func returnRightButtons() -> [AnyObject] {
        
        let btn1 = UIButton(frame: CGRectMake(0,0,88,88))
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("编辑", forState: .Normal)
        
        let btn2 = UIButton(frame:CGRectMake(0,0,88,88))
        btn2.backgroundColor = UIColor.redColor()
        btn2.setTitle("删除", forState: .Normal)
        
        return [btn1,btn2]

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = BookDetailViewController()
        vc.BookObject = self.dataArray[indexPath.row] as? AVObject
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    /**
     SWTableViewCellDelegate
     */
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        if state == .CellStateRight{
            if self.swipIndexPath != nil && self.swipIndexPath?.row != indexPath?.row {
                let swipedCell = self.tableView?.cellForRowAtIndexPath(self.swipIndexPath!) as? Push_BookCell
                swipedCell?.hideUtilityButtonsAnimated(true)
            }
            self.swipIndexPath = indexPath
        }else if state == .CellStateCenter{
            self.swipIndexPath = nil
        }
    }
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        cell.hideUtilityButtonsAnimated(true)
        
        let indexPath = self.tableView?.indexPathForCell(cell)
        
        let object = self.dataArray[indexPath!.row] as? AVObject
//
        if index == 0 {  //编辑
            let vc = pushNewBookViewController()
            GeneralFactory.addTitleViewWithTitle(vc, title1: "关闭", title2: "发布")
            
//
            vc.fixType = "fix"
            vc.BookObject = object
            vc.fixBook()
            self.presentViewController(vc, animated: true, completion: { () -> Void in
            })
        }else{     //删除
            ProgressHUD.show("")
            
            let discussQuery = AVQuery(className: "discuss")
            discussQuery.whereKey("BookObject", equalTo: object)
            discussQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
            
            let loveQuery = AVQuery(className: "Love")
            loveQuery.whereKey("BookObject", equalTo: object)
            loveQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
        
            object?.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    ProgressHUD.showSuccess("删除成功")
                    self.dataArray.removeObjectAtIndex((indexPath?.row)!)
                    self.tableView?.reloadData()
                    
                    
                }else{
                    
                }
            })
            
            
        }
        
        
    }

}
