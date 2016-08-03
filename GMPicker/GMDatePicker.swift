//
//  GMDatePicker.swift
//  GMPicker
//
//  Created by Gabor Csontos on 8/3/16.
//  Copyright © 2016 GabeMajorszki. All rights reserved.
//

import UIKit

protocol GMDatePickerDelegate: class {
    
    func gmDatePicker(gmDatePicker: GMDatePicker, didSelect date: NSDate)
    func gmDatePickerDidCancelSelection(gmDatePicker: GMDatePicker)
    
}

class GMDatePicker: UIView {
    
    // MARK: - Config
    struct Config {
        
        private let contentHeight: CGFloat = 250
        private let bouncingOffset: CGFloat = 20
        
        var startDate: NSDate?
        
        var confirmButtonTitle = "Confirm"
        var cancelButtonTitle = "Cancel"
        var buttonFontSize:CGFloat = 14
        
        var headerHeight: CGFloat = 50
        
        var animationDuration: NSTimeInterval = 0.5
        
        var contentBackgroundColor: UIColor = UIColor.whiteColor()
        var headerBackgroundColor: UIColor = UIColor.lightGrayColor()
        var confirmButtonColor: UIColor = UIColor.blueColor()
        var cancelButtonColor: UIColor = UIColor.blueColor()
        
        var overlayBackgroundColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        
    }
    
    var config = Config()
    
    weak var delegate: GMDatePickerDelegate?
    
    // MARK: - Variables
    var datePicker = UIDatePicker()
    var confirmButton = UIButton()
    var cancelButton = UIButton()
    var headerView = UIView()
    var backgroundView = UIView()
    var headerViewHeightConstraint: NSLayoutConstraint!
    
    var bottomConstraint: NSLayoutConstraint!
    var overlayButton: UIButton!
    
    
    
    // MARK: - ButtonTouched
    func confirmButtonDidTapped(sender: AnyObject) {
        
        config.startDate = datePicker.date
        dismiss()
        delegate?.gmDatePicker(self, didSelect: datePicker.date)
        
    }
     func cancelButtonDidTapped(sender: AnyObject) {
        dismiss()
        delegate?.gmDatePickerDidCancelSelection(self)
    }
    
    
    
    
    // MARK: - Private
    private func setup(parentVC: UIViewController) {
        
        
        // Loading configuration
        
        if let startDate = config.startDate {
            datePicker.date = startDate
        }
        

        // Loading configuration
        confirmButton.setTitle(config.confirmButtonTitle, forState: .Normal)
        cancelButton.setTitle(config.cancelButtonTitle, forState: .Normal)
        
        confirmButton.setTitleColor(config.confirmButtonColor, forState: .Normal)
        cancelButton.setTitleColor(config.cancelButtonColor, forState: .Normal)
        
        headerView.backgroundColor = config.headerBackgroundColor
        backgroundView.backgroundColor = config.contentBackgroundColor
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        overlayButton.backgroundColor = config.overlayBackgroundColor
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), forControlEvents: .TouchUpInside)
        
        if !overlayButton.isDescendantOfView(parentVC.view) { parentVC.view.addSubview(overlayButton)}
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentVC.view.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .Bottom, relatedBy: .Equal, toItem: parentVC.view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .Top, relatedBy: .Equal, toItem: parentVC.view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .Leading, relatedBy: .Equal, toItem: parentVC.view, attribute: .Leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .Trailing, relatedBy: .Equal, toItem: parentVC.view, attribute: .Trailing, multiplier: 1, constant: 0)
            ]
        )
        

        
        
        // Setup picker constraints
        
        frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: config.contentHeight + config.headerHeight)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: parentVC.view, attribute: .Bottom, multiplier: 1, constant: 0)
        
        if !isDescendantOfView(parentVC.view) { parentVC.view.addSubview(self) }
        
        parentVC.view.addConstraints([
            bottomConstraint,
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: parentVC.view, attribute: .Leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: parentVC.view, attribute: .Trailing, multiplier: 1, constant: 0)
            ]
        )
        addConstraint(
            NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: frame.height)
        )
        
        
        if !headerView.isDescendantOfView(self) { addSubview(headerView)}
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        headerView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        headerView.heightAnchor.constraintEqualToConstant(config.headerHeight).active = true
        headerView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true

        if !confirmButton.isDescendantOfView(headerView) { headerView.addSubview(confirmButton)}
     
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.rightAnchor.constraintEqualToAnchor(headerView.rightAnchor).active = true
        confirmButton.topAnchor.constraintEqualToAnchor(headerView.topAnchor).active = true
        confirmButton.heightAnchor.constraintEqualToAnchor(headerView.heightAnchor).active = true
        confirmButton.widthAnchor.constraintEqualToConstant(78).active = true
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped), forControlEvents: .TouchUpInside)
        confirmButton.titleLabel?.font = UIFont.systemFontOfSize(config.buttonFontSize)
        
        if !cancelButton.isDescendantOfView(headerView) { headerView.addSubview(cancelButton)}
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraintEqualToAnchor(headerView.leftAnchor).active = true
        cancelButton.topAnchor.constraintEqualToAnchor(headerView.topAnchor).active = true
        cancelButton.heightAnchor.constraintEqualToAnchor(headerView.heightAnchor).active = true
        cancelButton.widthAnchor.constraintEqualToConstant(78).active = true
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTapped), forControlEvents: .TouchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFontOfSize(config.buttonFontSize)

        if !backgroundView.isDescendantOfView(self) { addSubview(backgroundView)}
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        backgroundView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        backgroundView.heightAnchor.constraintEqualToConstant(config.contentHeight).active = true
        backgroundView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        
        if !datePicker.isDescendantOfView(backgroundView) { backgroundView.addSubview(datePicker)}
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.rightAnchor.constraintEqualToAnchor(backgroundView.rightAnchor).active = true
        datePicker.bottomAnchor.constraintEqualToAnchor(backgroundView.bottomAnchor).active = true
        datePicker.heightAnchor.constraintEqualToAnchor(backgroundView.heightAnchor).active = true
        datePicker.widthAnchor.constraintEqualToAnchor(backgroundView.widthAnchor).active = true
        
        datePicker.datePickerMode = .Date
        
        move(goUp: false)
        
    }
    private func move(goUp goUp: Bool) {
        bottomConstraint.constant = goUp ? config.bouncingOffset : config.contentHeight + config.headerHeight
    }
    
    // MARK: - Public
    func show(inVC parentVC: UIViewController, completion: (() -> ())? = nil) {
        
        setup(parentVC)
        move(goUp: true)
        
        UIView.animateWithDuration(
            config.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .CurveEaseIn, animations: {
                
                parentVC.view.layoutIfNeeded()
                self.overlayButton.alpha = 1
                
            }, completion: { (finished) in
                completion?()
            }
        )
        
    }
    func dismiss(completion: (() -> ())? = nil) {
        
        move(goUp: false)
        
        UIView.animateWithDuration(
            config.animationDuration, animations: {
                
                self.layoutIfNeeded()
                self.overlayButton.alpha = 0
                
            }, completion: { (finished) in
                completion?()
                self.removeFromSuperview()
                self.overlayButton.removeFromSuperview()
            }
        )
        
    }
}
