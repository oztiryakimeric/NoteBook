//
//  CommentDialog.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 7.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit


class CommentDialog: UIView, UITextViewDelegate {
    var material: Material?
    var user: User?
    
    var dataSource: CommentDataSource?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    static func create(dataDelegate: CommentDataDelegate, material: Material) -> CommentDialog{
        let view = Bundle.main.loadNibNamed("CommentDialog", owner: self, options: nil)?.first as! CommentDialog
        view.initialize(dataDelegate: dataDelegate, material: material)
        return view
    }
    
    private func initialize(dataDelegate: CommentDataDelegate, material: Material?){
        self.material = material
        self.user = AuthHelper.getCurrentUser()
        
        dataSource = CommentDataSource(material: material!, user: AuthHelper.getCurrentUser()!)
        dataSource!.delegate = dataDelegate
        
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    func show(){
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self);
        self.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        }, completion: nil)
    }
    
    private func remove(){
        let window = UIApplication.shared.keyWindow!
        textView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars <= 140;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let remaining = 140 - textView.text.characters.count
        characterCountLabel.text = "\(remaining)"
        
        if remaining < 20{
            characterCountLabel.textColor = UIColor.red
        }
        else{
            characterCountLabel.textColor = UIColor.black
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        remove()
    }
    
    @IBAction func onSendClicked(_ sender: Any) {
        dataSource!.postNewComment(comment: textView.text)
        remove()
    }
    
}
