//
//  LikeDataSource.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 6.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Alamofire

protocol LikeDataDelegate{
    func onFailure()
    func onSuccess()
}

class LikeDataSource{
    let material: Material
    let user: User
    
    var delegate: LikeDataDelegate?
    
    init(material: Material, user: User){
        self.material = material
        self.user = user
    }
    
    func like(){
        send(type: HTTPMethod.post)
    }
    
    func unlike(){
        send(type: HTTPMethod.delete)
    }
    
    private func send(type: HTTPMethod){
        var parameters: [String: String]? = nil
        var expectedCode: Int
        
        if type == HTTPMethod.post{
            parameters = ["material": "\(material.id!)", "owner": "\(user.id!)"]
            expectedCode = 200
        }else{
            parameters = ["material_code": "\(material.id!)", "user_code": "\(user.id!)"]
            expectedCode = 204
        }
        
        Alamofire.request(Api.favoriteUrl, method: type, parameters: parameters!).responseJSON() {
            (response) in
                        let statusCode = response.response?.statusCode
            statusCode == expectedCode ? self.delegate!.onSuccess() : self.delegate!.onFailure()
        }
    }
}
