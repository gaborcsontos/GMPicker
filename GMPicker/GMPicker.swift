//
//  GMPicker.swift
//  GMPicker
//
//  Created by Gabor Csontos on 8/3/16.
//  Copyright © 2016 GabeMajorszki. All rights reserved.
//

import UIKit


protocol GMPickerDelegate: class {
    
    func gmPicker(gmPicker: GMPicker, didSelect string: String)
    func gmPickerDidCancelSelection(gmPicker: GMPicker)
    
}


class GMPicker: UIView {
    
    // MARK: - Config
    struct Config {
        
        private let contentHeight: CGFloat = 250
        private let bouncingOffset: CGFloat = 10
        
        var confirmButtonTitle = "Confirm"
        var cancelButtonTitle = "Cancel"
        var buttonFontSize:CGFloat = 14
        
        var headerHeight: CGFloat = 50
        
        var animationDuration: NSTimeInterval = 0.5
        
        var contentBackgroundColor: UIColor = UIColor.lightGrayColor()
        var headerBackgroundColor: UIColor = UIColor.whiteColor()
        var confirmButtonColor: UIColor = UIColor.blueColor()
        var cancelButtonColor: UIColor = UIColor.blueColor()
        
        var overlayBackgroundColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.6) //UIColor.clearColor()
        
    }
    
    var config = Config()
    
    weak var delegate: GMPickerDelegate?
    
    // MARK: - Variables
    var gmpicker = UIPickerView()
    var confirmButton = UIButton()
    var cancelButton = UIButton()
    var headerView = UIView()
    var backgroundView = UIView()
    var headerViewHeightConstraint: NSLayoutConstraint!
    
    var bottomConstraint: NSLayoutConstraint!
    var overlayButton: UIButton!
    
    var Array = [String]()
    var placementAnswer = String()
    
    
    // MARK: - ButtonTouched
    func confirmButtonDidTapped(sender: AnyObject) {
        dismiss()
        delegate?.gmPicker(self, didSelect: placementAnswer)
        
    }
    
    func cancelButtonDidTapped(sender: AnyObject) {
        dismiss()
        delegate?.gmPickerDidCancelSelection(self)
    }
    
    
    
    func setupGender(){
        
        self.Array = ["Female", "Male"]
        gmpicker.reloadAllComponents()
    }
    
    
    func setupYears(){
        
        Array = [String]()
        var years: [String] = []
        
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(
            [.Year],
            value: -50,//set the years
            toDate: NSDate(),
            options: [])! //?? NSDate() if you want to choose date from now
        
      
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Year, fromDate: startDate)
            for _ in 1...51 {
                years.append(String(year))
                year += 1
            }
        }
        
        self.Array = years
        gmpicker.reloadAllComponents()
    }
    
    
    // MARK: - Private
    private func setup(parentVC: UIViewController) {
        
        
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
        
        //Setup subviews constrains
        if !headerView.isDescendantOfView(self) { addSubview(headerView)}
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        headerView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        headerView.heightAnchor.constraintEqualToConstant(config.headerHeight).active = true
        headerView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        
        
        if !confirmButton.isDescendantOfView(headerView) { headerView.addSubview(confirmButton)}
        //constrains
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.rightAnchor.constraintEqualToAnchor(headerView.rightAnchor).active = true
        confirmButton.topAnchor.constraintEqualToAnchor(headerView.topAnchor).active = true
        confirmButton.heightAnchor.constraintEqualToAnchor(headerView.heightAnchor).active = true
        confirmButton.widthAnchor.constraintEqualToConstant(78).active = true
        //target + title
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped), forControlEvents: .TouchUpInside)
        confirmButton.titleLabel?.font = UIFont.systemFontOfSize(config.buttonFontSize)
        
        
        if !cancelButton.isDescendantOfView(headerView) { headerView.addSubview(cancelButton)}
        //constrains
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraintEqualToAnchor(headerView.leftAnchor).active = true
        cancelButton.topAnchor.constraintEqualToAnchor(headerView.topAnchor).active = true
        cancelButton.heightAnchor.constraintEqualToAnchor(headerView.heightAnchor).active = true
        cancelButton.widthAnchor.constraintEqualToConstant(78).active = true
        //target + title
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTapped), forControlEvents: .TouchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFontOfSize(config.buttonFontSize)
        
        
        if !backgroundView.isDescendantOfView(self) { addSubview(backgroundView)}
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        backgroundView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        backgroundView.heightAnchor.constraintEqualToConstant(config.contentHeight).active = true
        backgroundView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        
        
        if !gmpicker.isDescendantOfView(backgroundView) { backgroundView.addSubview(gmpicker)}
        
        gmpicker.translatesAutoresizingMaskIntoConstraints = false
        gmpicker.rightAnchor.constraintEqualToAnchor(backgroundView.rightAnchor).active = true
        gmpicker.bottomAnchor.constraintEqualToAnchor(backgroundView.bottomAnchor).active = true
        gmpicker.heightAnchor.constraintEqualToAnchor(backgroundView.heightAnchor).active = true
        gmpicker.widthAnchor.constraintEqualToAnchor(backgroundView.widthAnchor).active = true
        
        gmpicker.dataSource = self
        gmpicker.delegate = self
        
        gmpicker.selectRow(Array.endIndex - 1, inComponent: 0, animated: false)
        placementAnswer = Array[Array.endIndex - 1]
        
        
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

extension GMPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Array.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array[row]
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placementAnswer = Array[row]
    }
}