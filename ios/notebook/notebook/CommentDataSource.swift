//
//  CommentDataSource.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 6.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

@objc protocol CommentDataDelegate{
    @objc optional func commentListDataUpdated()
    @objc optional func commentPosted()
}

class CommentDataSource{
    let material: Material
    let user: User
    
    var delegate: CommentDataDelegate?
    
    var commentList: [Comment] = []
    var currentPage = 2
    var isLoading = false
    
    init(material: Material, user: User){
        self.material = material
        self.user = user
    }
    
    func getInitialComments(){
        getCommentsAtPage(page: 1)
    }
    
    func getNextPage(){
        let olCount = commentList.count
        getCommentsAtPage(page: currentPage)
        if(olCount != commentList.count){
            currentPage += 1
        }
    }
    
    func reloadData(){
        commentList.removeAll()
        delegate?.commentListDataUpdated!()
        getCommentsAtPage(page: 1)
        delegate?.commentListDataUpdated!()
    }
    
    func postNewComment(comment: String){
        let parameters = ["material": "\(material.id!)", "owner": "\(user.id!)", "comment": comment]
        
        Alamofire.request(Api.commentUrl, method: .post, parameters: parameters).responseJSON() {
            (response) in
            self.delegate?.commentPosted!()
        }
        
    }
    
    private func getCommentsAtPage(page: Int){
        isLoading = true
        let parameters = ["page": "\(page)", "material_code": "\(material.id!)"]
        
        Alamofire.request(Api.commentUrl, method: .get, parameters: parameters).responseJSON() {
            (response) in
            do{
                self.commentList.append(contentsOf: try unbox(data:response.data!))
                self.delegate?.commentListDataUpdated!()
                self.isLoading = false
            }catch{
                print("Error while downloading")
            }
        }
    }
    
    func giveComment(indexPath: IndexPath) -> Comment{
        return commentList[indexPath.row]
    }
}


