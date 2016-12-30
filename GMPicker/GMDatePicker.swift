//
//  GMDatePicker.swift
//  GMPicker
//
//  Created by Gabor Csontos on 8/3/16.
//  Copyright © 2016 GabeMajorszki. All rights reserved.
//

import UIKit

protocol GMDatePickerDelegate: class {
    
    func gmDatePicker(_ gmDatePicker: GMDatePicker, didSelect date: Date)
    func gmDatePickerDidCancelSelection(_ gmDatePicker: GMDatePicker)
    
}

class GMDatePicker: UIView {
    
    // MARK: - Config
    struct Config {
        
        fileprivate let contentHeight: CGFloat = 250
        fileprivate let bouncingOffset: CGFloat = 20
        
        var startDate: Date?
        
        var confirmButtonTitle = "Confirm"
        var cancelButtonTitle = "Cancel"
        var buttonFontSize:CGFloat = 14
        
        var headerHeight: CGFloat = 50
        
        var animationDuration: TimeInterval = 0.5
        
        var contentBackgroundColor: UIColor = UIColor.white
        var headerBackgroundColor: UIColor = UIColor.lightGray
        var confirmButtonColor: UIColor = UIColor.blue
        var cancelButtonColor: UIColor = UIColor.blue
        
        var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)
        
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
    func confirmButtonDidTapped(_ sender: AnyObject) {
        
        config.startDate = datePicker.date
        dismiss()
        delegate?.gmDatePicker(self, didSelect: datePicker.date)
        
    }
     func cancelButtonDidTapped(_ sender: AnyObject) {
        dismiss()
        delegate?.gmDatePickerDidCancelSelection(self)
    }
    
    
    
    
    // MARK: - Private
    fileprivate func setup(_ parentVC: UIViewController) {
        
        
        // Loading configuration
        
        if let startDate = config.startDate {
            datePicker.date = startDate
        }
        

        // Loading configuration
        confirmButton.setTitle(config.confirmButtonTitle, for: UIControlState())
        cancelButton.setTitle(config.cancelButtonTitle, for: UIControlState())
        
        confirmButton.setTitleColor(config.confirmButtonColor, for: UIControlState())
        cancelButton.setTitleColor(config.cancelButtonColor, for: UIControlState())
        
        headerView.backgroundColor = config.headerBackgroundColor
        backgroundView.backgroundColor = config.contentBackgroundColor
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayButton.backgroundColor = config.overlayBackgroundColor
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), for: .touchUpInside)
        
        if !overlayButton.isDescendant(of: parentVC.view) { parentVC.view.addSubview(overlayButton)}
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentVC.view.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: parentVC.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        

        
        
        // Setup picker constraints
        
        frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: config.contentHeight + config.headerHeight)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        if !isDescendant(of: parentVC.view) { parentVC.view.addSubview(self) }
        
        parentVC.view.addConstraints([
            bottomConstraint,
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        addConstraint(
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: frame.height)
        )
        
        
        if !headerView.isDescendant(of: self) { addSubview(headerView)}
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: config.headerHeight).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        if !confirmButton.isDescendant(of: headerView) { headerView.addSubview(confirmButton)}
     
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 78).isActive = true
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped), for: .touchUpInside)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: config.buttonFontSize)
        
        if !cancelButton.isDescendant(of: headerView) { headerView.addSubview(cancelButton)}
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 78).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: config.buttonFontSize)

        if !backgroundView.isDescendant(of: self) { addSubview(backgroundView)}
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: config.contentHeight).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        if !datePicker.isDescendant(of: backgroundView) { backgroundView.addSubview(datePicker)}
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: backgroundView.heightAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
        
        datePicker.datePickerMode = .date
        
        move(goUp: false)
        
    }
    fileprivate func move(goUp: Bool) {
        bottomConstraint.constant = goUp ? config.bouncingOffset : config.contentHeight + config.headerHeight
    }
    
    // MARK: - Public
    func show(inVC parentVC: UIViewController, completion: (() -> ())? = nil) {
        
        setup(parentVC)
        move(goUp: true)
        
        UIView.animate(
            withDuration: config.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
                
                parentVC.view.layoutIfNeeded()
                self.overlayButton.alpha = 1
                
            }, completion: { (finished) in
                completion?()
            }
        )
        
    }
    func dismiss(_ completion: (() -> ())? = nil) {
        
        move(goUp: false)
        
        UIView.animate(
            withDuration: config.animationDuration, animations: {
                
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
