//
//  MaterialListDataSource.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 30.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

@objc protocol MaterialListDataDelegate{
    @objc optional func onDataUpdate();
}

enum HolderType{
    case User, Class
}

class MaterialListDataSource{
    let dataDelegate: MaterialListDataDelegate
    
    var _class: Class?
    let user: User
    var forShared: Bool = false
    var forFavorited: Bool = false
    
    var requestParameters: [String: String] {
        if _class != nil{
            return ["class_code": "\(_class!.id)", "user_code" : "\(user.id!)"]
        }
        else{
            if forShared{
                return ["user_code" : "\(user.id!)"]
            }
            else{
                return ["user_code" : "\(user.id!)", "favorited" : "1"]
            }
        }
    }
    
    var materialList: [Material] = []
    var currentPage = 2
    var isLoading = false
   
    static func belongToClass(_class: Class, currentUser: User, delegate: MaterialListDataDelegate) -> MaterialListDataSource{
        let source = MaterialListDataSource(user: currentUser, delegate: delegate)
        source._class = _class
        return source
    }
    
    static func sharedByUser(user: User, delegate: MaterialListDataDelegate) -> MaterialListDataSource{
        let source = MaterialListDataSource(user: user, delegate: delegate)
        source.forFavorited = false
        source.forShared = true
        return source
    }
    
    static func favoritedByUser(user: User, delegate: MaterialListDataDelegate) -> MaterialListDataSource{
        let source = MaterialListDataSource(user: user, delegate: delegate)
        source.forFavorited = true
        source.forShared = false
        return source
    }
    
    init(user: User, delegate: MaterialListDataDelegate){
        self.user = user
        self.dataDelegate = delegate;
    }
    
    func getInitialMaterialList(){
        getMaterialsAtPage(page: 1)
    }
    
    func reloadData(){
        materialList.removeAll()
        dataDelegate.onDataUpdate!()
        getMaterialsAtPage(page: 1)
    }
    
    func getNextPage(){
        let oldCount = materialList.count
        getMaterialsAtPage(page: currentPage)
        if(oldCount != materialList.count){
            currentPage += 1
        }
    }
    
    private func getMaterialsAtPage(page: Int){
        isLoading = true
        print("Material list request send for page: \(page)")
        var parameters = ["page": "\(page)"]
        for (key,value) in requestParameters {
            parameters.updateValue(value, forKey:key)
        }

        Alamofire.request(Api.materialUrl, method: .get, parameters: parameters).responseJSON() {
            (response) in
            do{
                self.materialList.append(contentsOf: try unbox(data:response.data!))
                self.dataDelegate.onDataUpdate!()
                self.isLoading = false
            }catch{
                print("Error while downloading")
            }
        }
    }
    
    func giveMaterial(indexPath: IndexPath) -> Material{
        return materialList[indexPath.row]
    }
    
    private func giveClassId() -> Int{
        return _class!.id
    }
    
    private func giveUserId() -> Int{
        return user.id!
    }
}
