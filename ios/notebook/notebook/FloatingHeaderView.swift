//
//  FloatingHeaderView.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 7.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate{
    func updateView()
}

@IBDesignable class FloatingHeaderView: UIView{
    var contentView : UIView!
    var delegate: HeaderViewDelegate?
    
    var height: NSLayoutConstraint?
    
    @IBOutlet weak var label: UILabel!
    
    var isShrinked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(contentView)
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func shrinkHeaderView(value: CGFloat){
        height!.constant = 150 - value
        isShrinked = true
        delegate!.updateView()
    }
    
    func shrinkHeaderViewToMin(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.height!.constant = 50
            self.delegate!.updateView()
        }, completion: nil)
        isShrinked = true
    }
    
    func expandHeaderView(value: CGFloat){
        self.height!.constant = 150 - value
        isShrinked = false
        delegate!.updateView()
    }
    
    func expandHeaderViewToMax(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options:  [.allowUserInteraction, .curveEaseInOut], animations: {
            self.height!.constant = 150
            self.delegate!.updateView()
        }, completion: nil)
        isShrinked = false
    }}
