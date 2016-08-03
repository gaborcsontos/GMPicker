//
//  ViewController.swift
//  GMPicker
//
//  Created by Gabor Csontos on 8/3/16.
//  Copyright © 2016 GabeMajorszki. All rights reserved.
//

import UIKit

extension ViewController: GMDatePickerDelegate {
    
    func gmDatePicker(gmDatePicker: GMDatePicker, didSelect date: NSDate){
        print(date)
        dateOfBirth.text = dateFormatter.stringFromDate(date)
    }
    func gmDatePickerDidCancelSelection(gmDatePicker: GMDatePicker) {
        
    }
    
    private func setupDatePicker() {
        
        datePicker.delegate = self
        
        datePicker.config.startDate = NSDate()
        
        datePicker.config.animationDuration = 0.5
        
        datePicker.config.cancelButtonTitle = "Cancel"
        datePicker.config.confirmButtonTitle = "Confirm"
        
        datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        datePicker.config.confirmButtonColor = UIColor.blackColor()
        datePicker.config.cancelButtonColor = UIColor.blackColor()
        
    }
}

extension ViewController: GMPickerDelegate {
    
    func gmPicker(gmPicker: GMPicker, didSelect string: String) {
        
        if !isYearPicked{userGender.text = string} else { year.text = string }
        
    }
    
    func gmPickerDidCancelSelection(gmPicker: GMPicker){
        
    }
    
    private func setupPickerView(){
        
        picker.delegate = self
        picker.config.animationDuration = 0.5
        
        picker.config.cancelButtonTitle = "Cancel"
        picker.config.confirmButtonTitle = "Confirm"
        
        picker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        picker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        picker.config.confirmButtonColor = UIColor.blackColor()
        picker.config.cancelButtonColor = UIColor.blackColor()
        
    }
    
}


class ViewController: UIViewController {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.text = "WELCOME TO GMPICKER"
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        return label
    }()
    
    
    let userGender: UITextView = {
        let gender = UITextView()
        gender.layer.cornerRadius = 6
        gender.layer.borderColor = UIColor.blackColor().CGColor
        gender.layer.borderWidth = 0.5
        gender.clipsToBounds = true
        gender.textAlignment = .Center
        gender.font = UIFont.systemFontOfSize(12)
        gender.textColor = UIColor.blackColor()
        gender.text = "User Gender"
        gender.userInteractionEnabled = true
        gender.scrollEnabled = false
        gender.editable = false
        return gender
    }()
    
    let year: UITextView = {
        let year = UITextView()
        year.layer.cornerRadius = 6
        year.layer.borderColor = UIColor.blackColor().CGColor
        year.layer.borderWidth = 0.5
        year.clipsToBounds = true
        year.textAlignment = .Center
        year.font = UIFont.systemFontOfSize(12)
        year.textColor = UIColor.blackColor()
        year.text = "Annus Mirabilis"
        year.userInteractionEnabled = true
        year.scrollEnabled = false
        year.editable = false
        return year
    }()
    
    let dateOfBirth: UITextView = {
        let dob = UITextView()
        dob.layer.cornerRadius = 6
        dob.layer.borderColor = UIColor.blackColor().CGColor
        dob.layer.borderWidth = 0.5
        dob.clipsToBounds = true
        dob.textAlignment = .Center
        dob.font = UIFont.systemFontOfSize(12)
        dob.textColor = UIColor.blackColor()
        dob.text = "Date of birth"
        dob.userInteractionEnabled = true
        dob.scrollEnabled = false
        dob.editable = false
        return dob
    }()
    
    var picker = GMPicker()
    var isYearPicked = false
    
    var datePicker = GMDatePicker()
    var dateFormatter = NSDateFormatter()

    func chooseGender(){
        isYearPicked = false
        picker.setupGender()
        picker.show(inVC: self)
    }
    
    func chooseYear(){
        isYearPicked = true
        picker.setupYears()
        picker.show(inVC: self)
    }
    
    func chooseDOB(){
        datePicker.show(inVC: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(textLabel)
        textLabel.frame = CGRectMake(24, 160, self.view.frame.width - 24 - 24, 60)
        
        view.addSubview(userGender)
        userGender.frame = CGRectMake(24, 250, self.view.frame.width - 24 - 24, 30)
        userGender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseGender)))
        
        view.addSubview(year)
        year.frame = CGRectMake(24, 250 + 30 + 10, self.view.frame.width - 24 - 24, 30)
        year.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseYear)))
        
        view.addSubview(dateOfBirth)
        dateOfBirth.frame = CGRectMake(24, 250 + 30 + 10 + 30 + 10, self.view.frame.width - 24 - 24, 30)
        dateOfBirth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseDOB)))
        
        setupPickerView()
        dateFormatter.dateFormat = "dd MM yyyy"
        setupDatePicker()
    }
}