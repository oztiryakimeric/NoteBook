//
//  ProfileDialog.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 18.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class ProfileDialog: UIView, UITextFieldDelegate {

    var controller: UIViewController?
    var user: User?
    var delegate: CustomDialogDelegate?
    
    var effectHolder: UIVisualEffect?
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var mainRect: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var secondNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mainRect.layer.cornerRadius = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func create(controller: UIViewController, user: User) -> ProfileDialog{
        let view = Bundle.main.loadNibNamed("ProfileDialog", owner: self, options: nil)?.first as! ProfileDialog
        view.initialize(controller: controller, user: user)
        view.cropCorners()
        return view
    }
    
    private func initialize(controller: UIViewController, user: User){
        self.controller = controller
        self.user = user
        self.delegate = controller as? CustomDialogDelegate
        self.frame = CGRect(x: 0, y: 0, width: self.controller!.view.frame.width, height: self.controller!.view.frame.height)
        holdEffect()
        
        firstNameLabel.delegate = self
        secondNameLabel.delegate = self
        emailLabel.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        firstNameLabel.resignFirstResponder()
        secondNameLabel.resignFirstResponder()
        emailLabel.resignFirstResponder()
        return true;
    }
    
    private func cropCorners(){
        mainRect.layer.cornerRadius = 15
        headerLabel.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 15
        logOutButton.layer.cornerRadius = 15
    }
    
    private func holdEffect(){
        effectHolder = blurEffect.effect
        blurEffect.effect = nil
    }
    
    func show(){
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self);
        
        self.alpha = 0
        self.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
            self.blurEffect.effect = self.effectHolder
        }, completion: nil)
    }
    
    private func remove(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
            self.blurEffect.effect = nil
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func onLogOutClicked(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(nil, forKey: "user")
        userDefaults.setValue(nil, forKey: "password")
        controller!.performSegue(withIdentifier: "open_login_page", sender: (Any).self)
    }
    
    private func getDataFromUser(){
        let firstName = firstNameLabel.text
        if(firstName?.characters.count != 0){
            user!.first_name = firstName
        }
        
        let lastName = secondNameLabel.text
        if(lastName?.characters.count != 0){
            user!.second_name = lastName
        }
        
        let email = emailLabel.text
        if(email?.characters.count != 0){
            user!.email = email
        }
    }
    
    @IBAction func onClickDoneButton(_ sender: Any) {
        let authHelper: AuthHelper = AuthHelper()
        authHelper.delegate = controller as? AuthDelegate
        
        getDataFromUser()
        
        authHelper.updateUser(user: user!)
        remove()
        delegate?.onDialogClose()
    }
    
    @IBAction func onClickCancelButton(_ sender: Any) {
        remove()
        delegate?.onDialogClose()
    }
}
