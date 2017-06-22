//
//  CreateMaterialView.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 3.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

protocol CustomDialogDelegate{
    func onDialogClose()
}

class MaterialDialog: UIView, UITextFieldDelegate {
    
    var delegate: CustomDialogDelegate?
    
    var controller: UIViewController?
    var material: Material?
    var classId: Int?
    
    var effectHolder: UIVisualEffect?
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var mainRect: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var headerTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var fileUrlTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mainRect.layer.cornerRadius = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func create(controller: UIViewController, classId: Int) -> MaterialDialog{
        let view = Bundle.main.loadNibNamed("MaterialDialog", owner: self, options: nil)?.first as! MaterialDialog
        view.initialize(controller: controller, classId: classId)
        view.cropCorners()
        return view
    }
    
    private func initialize(controller: UIViewController, classId: Int){
        self.controller = controller
        self.classId = classId
        self.delegate = controller as? CustomDialogDelegate
        self.frame = CGRect(x: 0, y: 0, width: self.controller!.view.frame.width, height: self.controller!.view.frame.height)
        holdEffect()
        
        headerTextField.delegate = self
        descriptionTextField.delegate = self
        fileUrlTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        headerTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        fileUrlTextField.resignFirstResponder()
        return true;
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
    
    private func cropCorners(){
        mainRect.layer.cornerRadius = 15
        titleLabel.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 15
    }
    
    private func holdEffect(){
        effectHolder = blurEffect.effect
        blurEffect.effect = nil
    }
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        remove()
        delegate?.onDialogClose()
    }
    
    @IBAction func onDoneButtonClicked(_ sender: Any) {
        material = Material(ownerClass: classId!,
                            ownerUser: "\(AuthHelper.getCurrentUser()!.id!)",
                            header: headerTextField.text!,
                            description: descriptionTextField.text!,
                            fileUrl: fileUrlTextField.text!)
        
        let dataSource: MaterialDataSource = MaterialDataSource(material: material!)
        dataSource.dataDelegate = controller as? MaterialDataDelegate
        
        dataSource.postMaterial()
        
        remove()
        delegate?.onDialogClose()
    }
}








