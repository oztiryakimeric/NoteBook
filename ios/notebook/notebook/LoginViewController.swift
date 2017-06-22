//
//  LoginViewController.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 15.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit
import Wrap

class LoginViewController: UIViewController, AuthDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var formStack: UIStackView!
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var initialBackgroundColor: UIColor!
    var initialLoginButtonColor: UIColor!
    var initialSignupButtonColor: UIColor!
    
    let loginState = 0
    let signupState = 1
    
    var state: Int!
    
    let authHelper = AuthHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authHelper.delegate = self
        
        saveInitialColors()
        state = loginState
    }
    
    func saveInitialColors(){
        initialBackgroundColor = self.view.backgroundColor!
        initialLoginButtonColor = self.topButton.backgroundColor!
        initialSignupButtonColor = self.bottomButton.backgroundColor!
    }
    
    @IBAction func onTopButtonClicked(_ sender: Any) {
        let user = User(username: usernameTextField.text!, password: passwordTextField.text!)
        self.state == self.loginState ? authHelper.login(user: user) : authHelper.signup(user: user)
    }
    
    @IBAction func onBottomButtonClicked(_ sender: Any) {
        changeState()
    }
    
    func changeState(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.showHideSignupFields()
            self.changeColors(toState: self.state == self.loginState ? self.signupState : self.loginState)
            self.changeButtonTexts(toState: self.state == self.loginState ? self.signupState : self.loginState)
            
            self.state = self.state == self.loginState ? self.signupState : self.loginState
            
        }, completion: nil)
    }
    
    func showHideSignupFields(){
        self.formStack.arrangedSubviews[2].isHidden = !self.formStack.arrangedSubviews[2].isHidden
    }
    
    func changeColors(toState: Int){
        if(state == signupState){
            self.view.backgroundColor = initialBackgroundColor
            self.topButton.backgroundColor = initialLoginButtonColor
            self.bottomButton.backgroundColor = initialSignupButtonColor
        }
        else if(state == loginState){
            self.view.backgroundColor = initialSignupButtonColor
            self.topButton.backgroundColor = initialBackgroundColor
            self.bottomButton.backgroundColor = UIColor.orange
        }
    }
    
    func changeButtonTexts(toState: Int){
        if(state == signupState){
            topButton.setTitle("Login", for: .normal)
            bottomButton.setTitle("Signup", for: .normal)
        }
        else if(state == loginState){
            topButton.setTitle("Signup", for: .normal)
            bottomButton.setTitle("Cancel", for: .normal)
        }
    }
    
    func loginSuccess() {
        setMessageLabelText(messageText: "login :)")
        enterApp()
    }
    
    func signupSuccess() {
        setMessageLabelText(messageText: "signup :)")
        enterApp()
    }
    
    func enterApp(){
        performSegue(withIdentifier: "toMainView", sender: (Any).self)
    }
    
    func loginFail() {
        setMessageLabelText(messageText: "Control your credentials")
    }
    
    func signupFail(errorMessage: String) {
        setMessageLabelText(messageText: errorMessage)
    }
    
    func setMessageLabelText(messageText: String){
        self.messageLabel.text = messageText
        UIView.animate(withDuration: 0.2, animations: {
            self.messageLabel.alpha = 1
        }) { (complete) in
            UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseInOut, animations: {
                self.messageLabel.alpha = 0
            }, completion: nil)
        }
    }
}
