//
//  AuthHelper.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 15.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

@objc protocol AuthDelegate{
    @objc optional func loginSuccess()
    @objc optional func loginFail()
    @objc optional func signupSuccess()
    @objc optional func signupFail(errorMessage: String)
    @objc optional func userFound(user: User)
    @objc optional func userUpdated(user: User)
}

class AuthHelper: NSObject{
    let successMessage = "success"
    
    var delegate: AuthDelegate?
    
    func login(user: User){
        print("Login request sent")
        Alamofire.request(Api.loginUrl, method: .post, parameters: user.toJson()).responseString {
            (response) in
            do{
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let userCredentials: User = try unbox(data:response.data!)
                    self.saveCredentials(user: userCredentials)
                    self.savePassword(password: user.password!)
                    self.delegate?.loginSuccess!()
                }
                else{
                    self.delegate?.loginFail!()
                }
            }
            catch{
                self.delegate?.loginFail!()
            }
        }
    }
    
    func signup(user: User){
        print("Signup request sent")
        
        if(self.controlPassword(password: user.password!) && self.controlUsername(username: user.username)){
            Alamofire.request(Api.signupUrl, method: .post, parameters: user.toJson()).responseJSON() {
                (response) in
                do{
                    
                    let statusCode = response.response?.statusCode
                    if statusCode == 201 {
                        let userCredentials: User = try unbox(data:response.data!)
                        self.saveCredentials(user: userCredentials)
                        self.savePassword(password: user.password!)
                        self.delegate?.signupSuccess!()
                    }
                    else{
                        self.delegate?.signupFail!(errorMessage: "A user with that username already exists.")
                    }
                }
                catch{
                    self.delegate?.signupFail!(errorMessage: "Error. Try again...")
                }
            }
        }
    }
    
    static func getCurrentUser() -> User?{
        let userDefaults = UserDefaults.standard
        do{
            let userDict = userDefaults.object(forKey: "user")
            
            if userDict != nil{
                let user: User = try unbox(dictionary:  userDict as! UnboxableDictionary)
                return user
            }
        }
        catch{
            print("Error on getCurrentUser")
        }
        return nil
    }
    
    func getUser(withUsername: String){
        let paramaters = ["username": withUsername]
        Alamofire.request(Api.signupUrl, method: .get, parameters: paramaters).responseJSON() {
            (response) in
            
            do{
                let user: User = try unbox(data:response.data!)
                self.delegate!.userFound!(user: user)
            }
            catch{
                print("User can not found")
            }
            
        }
    }
    
    func updateUser(user: User){
        let url = "\(Api.signupUrl)?user_code=\(user.id!)"
        user.password = self.getPassword()
        Alamofire.request(url, method: .put, parameters: user.toJson()).responseJSON() {
            (response) in
            print(response)
            do{
                let user: User = try unbox(data:response.data!)
                self.saveCredentials(user: user)
                self.delegate?.userUpdated!(user: user)
            }
            catch{
                print("User can not found")
            }
        }
    }
    
    private func saveCredentials(user: User){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(user.toJson(), forKey: "user")
    }
    
    private func savePassword(password: String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(password, forKey: "password")
    }
    
    private func getPassword() -> String{
        let userDefaults = UserDefaults.standard
        let password: String = userDefaults.object(forKey: "password") as! String
        return password
    }
    
    func controlPassword(password: String) -> Bool{
        if password.characters.count < 6 {
            self.delegate?.signupFail!(errorMessage: "Your password should be greater than 6")
            return false
        }
        else if password.characters.count > 16{
            self.delegate?.signupFail!(errorMessage: "Your password should be lower than 16")
            return false
        }
        return true
    }
    
    func controlUsername(username: String) -> Bool{
        if username.characters.count < 6 {
            self.delegate?.signupFail!(errorMessage: "Your username should be greater than 6")
            return false
        }
        else if username.characters.count > 16{
            self.delegate?.signupFail!(errorMessage: "Your username should be lower than 16")
            return false
        }
        return true
    }
}









