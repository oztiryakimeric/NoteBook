//
//  FeedbackView.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 7.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

protocol FeedbackViewDelegate{
    func postFeedback(value: Int)
}

@IBDesignable class FeedbackView: UIView {
    var contentView : UIView!
    var delegate: FeedbackViewDelegate?
    
    @IBOutlet weak var averageFeedbackLabel: UILabel!
    @IBOutlet weak var sliderLabel: UILabel!
    
    var sliderValue: Int = 3
    
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
        
        self.sliderLabel.textColor = self.calculateColor(value: Double(sliderValue))
        self.sliderLabel.text = "\(sliderValue)"
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        let currentValue = Int((sender as! UISlider).value)
        changeSliderLabel(to: currentValue)
    }
    
    @IBAction func onGiveFeedbackButtonClicked(_ sender: Any) {
        delegate!.postFeedback(value: sliderValue)
    }
    
    private func changeSliderLabel(to: Int){
        if to == sliderValue{
            return
        }
        sliderValue = to
        UIView.animate(withDuration: 0.1, animations: {
            self.sliderLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.sliderLabel.text = "\(to)"
            self.sliderLabel.textColor = self.calculateColor(value: Double(to))
        }) { (success) in
            UIView.animate(withDuration: 0.1, animations: {
                self.sliderLabel.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func calculateColor(value: Double) -> UIColor{
        if value < 1{
            return UIColor.red
        }
        else if value < 2{
            return UIColor.orange
        }
        else if value < 3{
            return UIColor.yellow
        }
        else{
            return UIColor.green
        }
    }
    
    func animateFeedbackLabel(to: Double) {
        DispatchQueue.global().async {
            self.sleep(multiplier: to)
            var i = 0.0
            while i < ceil(to*100)/100{
                self.changeFeedbackLabel(to: i)
                i += 0.1
            }
            self.changeFeedbackLabel(to: i)
        }
    }
    
    private func changeFeedbackLabel(to: Double){
        self.sleep(multiplier: to)
        DispatchQueue.main.async {
            self.averageFeedbackLabel.text = "\(to)"
            self.averageFeedbackLabel.textColor = self.calculateColor(value: to)
        }
    }
    
    private func sleep(multiplier: Double){
        let sleepTime = UInt32(multiplier * 10000)
        usleep(sleepTime)
    }
}













