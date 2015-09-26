//
//  SlidePanelViewController.swift
//  SlideMenu
//
//  Created by Augus on 4/27/15.
//
//  http://iAugus.com
//  https://github.com/iAugux
//
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit
import SwiftyJSON


class SlidePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var userProfileImage: UIImageView!{
        didSet{
            userProfileImage.layer.cornerRadius = 35.0
            userProfileImage.clipsToBounds = true
            userProfileImage.layer.borderColor = UIColor.lightGrayColor().CGColor
            userProfileImage.layer.borderWidth = 0.3
            self.configureLoginAndLogoutView(userProfileImage)
            
        }
    }
    
    private let cellTitleArray = ["Notification", "Favorite", "Profile", "Setting"]
    private var blurView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_image_1")!)
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, atIndex: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.scrollEnabled = false
        IBBSContext.sharedInstance.configureCurrentUserAvatar(self.userProfileImage)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureLoginAndLogoutView(sender: UIImageView){
        let longTapGesture = UILongPressGestureRecognizer(target: self , action: "loginOrLogout:")
        sender.addGestureRecognizer(longTapGesture)
        sender.userInteractionEnabled = true
    }
    
    func loginOrLogout(gesture: UIGestureRecognizer){
        if gesture.state == .Began {
            IBBSContext.sharedInstance.isLogin(presentingVC: self){ (isLogin) -> Void in
                if isLogin {
                    // do logout
                    IBBSContext.sharedInstance.logout(presentingVC: self , completion: {
                        self.userProfileImage.image = UIImage(named: "login")
                    })
                }else{
                    // login or register
                    
                    self.alertToChooseLoginOrRegister()
                }
            }
        }
        
    }
    
    func alertToChooseLoginOrRegister(){
        let alertCtrl = UIAlertController(title: "", message: "Register or Login ? ", preferredStyle: .Alert)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) -> Void in
            // login
            IBBSContext.sharedInstance.login(presentingVC: self, completion: {
                IBBSContext.sharedInstance.configureCurrentUserAvatar(self.userProfileImage)
                self.tableView.reloadData()
            })
        }
        let registerAction = UIAlertAction(title: "Register", style: .Default) { (_) -> Void in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("iBBSRegisterViewController") as! IBBSRegisterViewController
            
//            UIView.animateWithDuration(0.75, animations: { () -> Void in
//                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
//                self.navigationController?.pushViewController(vc, animated: true)
//                UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view, cache: false)
//            })
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
        alertCtrl.addAction(loginAction)
        alertCtrl.addAction(registerAction)
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    
    // MARK: - table view delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = cellTitleArray[indexPath.row]
        return cell
    
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 50))
        headerView.backgroundColor = UIColor.grayColor()
        headerView.alpha = 0.3
        
        return headerView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("ok")
    }
   
}

