//
//  pushViewController.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class pushViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    
    var dataArray = NSMutableArray()
    
    var tableView:UITableView?
    
    
    
    
    
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
        let navigationView = UIView(frame:CGRectMake(0,-20,SCREEN_WIDTH,65))
        navigationView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar .addSubview(navigationView)
        
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    
    
}
