//
//  SecondViewController.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 15.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, MaterialListDataDelegate {
    
    var user: User?
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var materialList: ProfileMaterialListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Color.green
        UINavigationBar.appearance().tintColor = UIColor.black
        
        setLabelTexts()
        materialList.start(parent: self, user: user!)
    }
    
    private func setLabelTexts(){
        self.title = user!.username
        if user!.first_name == nil || user!.first_name?.characters.count == 0{
            firstName.text = "..."
        }
        else{
            firstName.text = user!.first_name
        }
        if user!.second_name == nil || user!.second_name?.characters.count == 0{
            secondNameLabel.text = "..."
        }
        else{
            secondNameLabel.text = user!.second_name
        }
        if user!.email == nil || user!.email?.characters.count == 0{
            emailLabel.text = "..."
        }
        else{
            emailLabel.text = user!.email
        }
    }
    
    @IBAction func onClickCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func onDataUpdate() {
        materialList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "open_material_screen") {
            let controller = segue.destination as! MaterialViewController
            
            controller.material = materialList.giveSelectedMaterial()
            //controller._class = _class!
            //controller.title = _class!.className
        }
        else if (segue.identifier == "open_profile_screen") {
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.viewControllers.first as! ProfileViewController
            
            let user = sender as! User
            
            controller.user = user
        }
    }
}

class CurrentProfileViewController: UIViewController, MaterialListDataDelegate, CustomDialogDelegate, AuthDelegate {

    var user: User = AuthHelper.getCurrentUser()!
    var isCurrentUser: Bool = true
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var materialList: ProfileMaterialListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Color.green
        UINavigationBar.appearance().tintColor = UIColor.black
        
        setLabelTexts()
        materialList.start(parent: self, user: user)
    }
    
    private func setLabelTexts(){
        usernameLabel.text = user.username
        
        if user.first_name == nil || user.first_name?.characters.count == 0{
            firstName.text = "..."
        }
        else{
            firstName.text = user.first_name
        }
        if user.second_name == nil || user.second_name?.characters.count == 0{
            secondName.text = "..."
        }
        else{
            secondName.text = user.second_name
        }
        if user.email == nil || user.email?.characters.count == 0{
            email.text = "..."
        }
        else{
            email.text = user.email
        }
    }
    
    func onDataUpdate() {
       materialList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "open_material_screen") {
            let controller = segue.destination as! MaterialViewController
            
            controller.material = materialList.giveSelectedMaterial()
        }
        
        if (segue.identifier == "open_profile_screen") {
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.viewControllers.first as! ProfileViewController
            
            let user = sender as! User
            
            controller.user = user
        }
    }
    
    @IBAction func onClickEditProfile(_ sender: Any) {
        let profileDialog: ProfileDialog = ProfileDialog.create(controller: self, user: user)
        profileDialog.show()
    }
    
    func onDialogClose(){
        print("Dialog Closed")
    }
    
    func userUpdated(user: User) {
        self.user = user
        setLabelTexts()
    }
}

