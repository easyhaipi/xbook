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
    
    var swipIndexPath:IndexPath?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setNavigationBar()
        
        
        
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.register(Push_BookCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.tableFooterView = UIView()
        
        
        
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget:self,refreshingAction:#selector(pushViewController.HeaderRefreshMore))
        self.tableView?.mj_footer = MJRefreshBackFooter(refreshingTarget:self,refreshingAction:#selector(pushViewController.FooterRefreshMore))
        
        
        
      self.tableView?.mj_header.beginRefreshing()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationView.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationView.isHidden = true
    }
    
    func HeaderRefreshMore(){
        
        let query = AVQuery(className: "Book")
        query?.order(byDescending: "createdAt")
        
        query?.limit = 20
        query?.skip = 0
        query?.whereKey("user", equalTo: AVUser.current())
        query?.findObjectsInBackground { (results, error) in
            self.tableView?.mj_header.endRefreshing()
            
    
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjects(from: results!)
            self.tableView?.reloadData()
            
            
        }
        
    }
    func FooterRefreshMore(){
        let query = AVQuery(className: "Book")
        query?.order(byDescending: "createdAt")
        
        query?.limit = 20
        query?.skip = self.dataArray.count
        query?.whereKey("user", equalTo: AVUser.current())
        query?.findObjectsInBackground { (results, error) in
            self.tableView?.mj_footer.endRefreshing()
            
            
         
            self.dataArray.addObjects(from: results!)
            self.tableView?.reloadData()
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setNavigationBar(){
        navigationView = UIView(frame: CGRect(x: 0,y: -20,width: SCREEN_WIDTH,height: 65))
        navigationView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(navigationView)
        
        
        let addBookButton = UIButton(frame:CGRect(x: 20,y: 20,width: SCREEN_WIDTH,height: 45))
        addBookButton.setImage(UIImage(named: "plus circle"), for: UIControlState())
        addBookButton.setTitleColor(UIColor.black, for: UIControlState())
        addBookButton.setTitle("     新建书评", for: UIControlState())
        addBookButton.titleLabel?.font = UIFont(name:MY_FONT,size: 15)
        addBookButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        addBookButton.addTarget(self, action:#selector(pushViewController.pushNewBookAction), for: .touchUpInside)
        
        
        navigationView .addSubview(addBookButton)
        
    }
    
    
    func pushNewBookAction(){
      
        
        
        let vc = pushNewBookViewController()
        GeneralFactory.addTitleViewWithTitle(vc)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as?Push_BookCell
        
        cell?.rightUtilityButtons = self.returnRightButtons()
        cell?.delegate = self
        
        
        let dict = self.dataArray[(indexPath as NSIndexPath).row] as?AVObject
        
        cell?.BookName?.text = "《"+(dict!["BookName"] as! String)+"》:"+(dict!["title"] as! String)
        cell?.Editor?.text = "作者:"+(dict!["BookEditor"] as! String)
        
        let date = dict!["createdAt"] as? Date
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.more?.text = format.string(from: date!)
        
        let coverFile = dict!["cover"] as? AVFile
        cell?.cover?.sd_setImage(with: URL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        return cell!
    }
    
    
    func returnRightButtons() -> [AnyObject] {
        
        let btn1 = UIButton(frame: CGRect(x: 0,y: 0,width: 88,height: 88))
        btn1.backgroundColor = UIColor.orange
        btn1.setTitle("编辑", for: UIControlState())
        
        let btn2 = UIButton(frame:CGRect(x: 0,y: 0,width: 88,height: 88))
        btn2.backgroundColor = UIColor.red
        btn2.setTitle("删除", for: UIControlState())
        
        return [btn1,btn2]

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        let vc = BookDetailViewController()
        vc.BookObject = self.dataArray[(indexPath as NSIndexPath).row] as? AVObject
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    /**
     SWTableViewCellDelegate
     */
    func swipeableTableViewCell(_ cell: SWTableViewCell!, scrollingTo state: SWCellState) {
        let indexPath = self.tableView?.indexPath(for: cell)
        if state == .cellStateRight{
            if self.swipIndexPath != nil && (self.swipIndexPath as NSIndexPath?)?.row != (indexPath as NSIndexPath?)?.row {
                let swipedCell = self.tableView?.cellForRow(at: self.swipIndexPath!) as? Push_BookCell
                swipedCell?.hideUtilityButtons(animated: true)
            }
            self.swipIndexPath = indexPath
        }else if state == .cellStateCenter{
            self.swipIndexPath = nil
        }
    }
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        cell.hideUtilityButtons(animated: true)
        
        let indexPath = self.tableView?.indexPath(for: cell)
        
        let object = self.dataArray[(indexPath! as NSIndexPath).row] as? AVObject
//
        if index == 0 {  //编辑
            let vc = pushNewBookViewController()
            GeneralFactory.addTitleViewWithTitle(vc, title1: "关闭", title2: "发布")
            
//
            vc.fixType = "fix"
            vc.BookObject = object
            vc.fixBook()
            self.present(vc, animated: true, completion: { () -> Void in
            })
        }else{     //删除
            ProgressHUD.show("")
            
            let discussQuery = AVQuery(className: "discuss")
            discussQuery?.whereKey("BookObject", equalTo: object)
            discussQuery?.findObjectsInBackground({ (results, error) -> Void in
                for Book in results! {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
            
            let loveQuery = AVQuery(className: "Love")
            loveQuery?.whereKey("BookObject", equalTo: object)
            loveQuery?.findObjectsInBackground({ (results, error) -> Void in
                for Book in results! {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
        
            object?.deleteInBackground({ (success, error) -> Void in
                if success {
                    ProgressHUD.showSuccess("删除成功")
                    self.dataArray.removeObject(at: ((indexPath as NSIndexPath?)?.row)!)
                    self.tableView?.reloadData()
                    
                    
                }else{
                    
                }
            })
            
            
        }
        
        
    }

}
