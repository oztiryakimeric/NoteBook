//
//  MaterialViewController.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 1.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class MaterialViewController: UIViewController, MaterialDataDelegate, HeaderViewDelegate, FeedbackViewDelegate, CommentDataDelegate{
    //var _class: Class?
    var material: Material?
    
    var dataSource: MaterialDataSource?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: FloatingHeaderView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var feedbackView: FeedbackView!
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var commentButton: CommentButton!
    @IBOutlet weak var commentTable: UITableView!
    
    @IBOutlet weak var usernameLabel: UsernameLabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var lastPosition: CGFloat = 0.0
    
    var commentDataSource: CommentDataSource?
    var commentTableDelegate: CommentTableDelegate?
    
    var isDialogShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = MaterialDataSource(material: material!)
        dataSource?.dataDelegate = self
        
        headerView.delegate = self
        headerView.height = height
        headerView.label.text = material?.header
        
        feedbackView.delegate = self
        feedbackView.animateFeedbackLabel(to: material!.feedback!)
        
        usernameLabel.start(controller: self, username: material!.ownerUser)
        
        descriptionLabel.text = material!.description
        
        likeButton.setMaterial(material: material!)
        commentButton.setMaterial(delegate: self, material: material!)
        
        commentDataSource = CommentDataSource(material: material!, user: AuthHelper.getCurrentUser()!)
        commentDataSource!.delegate = self
        
        commentTableDelegate = CommentTableDelegate(controller: self, dataSource: commentDataSource!)
        
        commentTable.dataSource = commentTableDelegate
        commentTable.delegate = commentTableDelegate
        
        commentDataSource!.getInitialComments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Closed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "open_profile_screen") {
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.viewControllers.first as! ProfileViewController
            
            let user = sender as! User
            
            controller.user = user
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll = self.scrollView.contentOffset.y
        if isPageGoesDown() {
            if scroll < 50{
                headerView.shrinkHeaderView(value: scroll)
            }
            else if scroll < 100{
                headerView.shrinkHeaderViewToMin()
            }
                
            else if headerView.isShrinked && (scroll > 100 || scroll < 100){
                headerView.shrinkHeaderViewToMin()
            }
        }
        if isPageGoesUp() {
            if scroll < 50{
                headerView.expandHeaderViewToMax()
            }
            else if scroll < 100{
                headerView.expandHeaderView(value: scroll)
            }
            else if !headerView.isShrinked && (scroll > 100 || scroll < 100){
                headerView.expandHeaderViewToMax()
            }
        }
        lastPosition = scroll
    }
    
    private func isPageGoesDown() -> Bool{
        let scroll = scrollView.contentOffset.y
        return scroll > 0 && scroll > lastPosition
    }
    @IBAction func onClickDownload(_ sender: Any) {
        print("Go to \(material!.fileUrl)")
        let url = URL(string: material!.fileUrl)
        UIApplication.shared.open(url!, options: [:], completionHandler: {
            (success) in
            print("Open \(url!): \(success)")
        })
    }
    
    private func isPageGoesUp() -> Bool{
        let scroll = scrollView.contentOffset.y
        return scroll > 0 && scroll < lastPosition
    }
    
    func updateView(){
        self.view.layoutIfNeeded()
    }
    
    func postFeedback(value: Int){
        dataSource!.sendFeedback(point: value)
    }
    
    func onFeedbackUpdate(to: Double){
        feedbackView.animateFeedbackLabel(to: to)
        material!.feedback! = to
    }
    
    func commentListDataUpdated() {
        commentTable.reloadData()
    }
    
    func commentPosted() {
        material!.commentCount! = material!.commentCount! + 1
        commentButton.setCommentCount()
        commentDataSource!.reloadData()
    }
    
    func onMaterialPost() {
        print("Material post")
    }
}
