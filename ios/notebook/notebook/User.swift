//
//  User.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 17.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Unbox
import Wrap

//{"id":5,"username":"SIGNUPTESTsdfasdf","first_name":"","last_name":"","email":""}

class User: NSObject, Unboxable{
    var id: Int?
    let username: String
    var password: String?
    var email: String?
    var first_name: String?
    var second_name: String?
    
    required init(unboxer: Unboxer) throws {
        self.id = unboxer.unbox(key: "id")
        self.username = try unboxer.unbox(key: "username")
        self.password = unboxer.unbox(key: "password")
        self.email = unboxer.unbox(key: "email")
        self.first_name = unboxer.unbox(key: "first_name")
        self.second_name = unboxer.unbox(key: "last_name")
    }
    
    init(id: Int, username: String, password: String, email: String, first_name: String, second_name: String) {
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.first_name = first_name
        self.second_name = second_name
    }
    
    init(username: String, password: String){
        self.username = username
        self.password = password
    }
    
    func toJson() -> [String: Any]?{
        do{
            return try wrap(self)
        }
        catch{
            print("Error on wraping user")
        }
        return nil
    }
}
