//
//  UsernameLabel.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 16.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class UsernameLabel: UILabel, UIGestureRecognizerDelegate, AuthDelegate {

    var controller: UIViewController?
    var username: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func start(controller: UIViewController, username: String){
        self.controller = controller
        self.username = username
        
        text = "@\(username)"
        textColor = UIColor.blue
        
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UsernameLabel.onClick))
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func onClick() {
        let authHelper = AuthHelper()
        authHelper.delegate = self
        
        authHelper.getUser(withUsername: username!)
    }
    
    func userFound(user: User) {
        controller!.performSegue(withIdentifier: "open_profile_screen", sender: user);
    }
}
