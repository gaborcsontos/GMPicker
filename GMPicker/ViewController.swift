//
//  ViewController.swift
//  GMPicker
//
//  Created by Gabor Csontos on 8/3/16.
//  Copyright © 2016 GabeMajorszki. All rights reserved.
//

import UIKit

extension ViewController: GMDatePickerDelegate {
    
    func gmDatePicker(_ gmDatePicker: GMDatePicker, didSelect date: Date){
        print(date)
        dateOfBirth.text = dateFormatter.string(from: date)
    }
    func gmDatePickerDidCancelSelection(_ gmDatePicker: GMDatePicker) {
        
    }
    
    fileprivate func setupDatePicker() {
        
        datePicker.delegate = self
        
        datePicker.config.startDate = Date()
        
        datePicker.config.animationDuration = 0.5
        
        datePicker.config.cancelButtonTitle = "Cancel"
        datePicker.config.confirmButtonTitle = "Confirm"
        
        datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        datePicker.config.confirmButtonColor = UIColor.black
        datePicker.config.cancelButtonColor = UIColor.black
        
    }
}

extension ViewController: GMPickerDelegate {
    
    func gmPicker(_ gmPicker: GMPicker, didSelect string: String) {
        
        if !isYearPicked{userGender.text = string} else { year.text = string }
        
    }
    
    func gmPickerDidCancelSelection(_ gmPicker: GMPicker){
        
    }
    
    fileprivate func setupPickerView(){
        
        picker.delegate = self
        picker.config.animationDuration = 0.5
        
        picker.config.cancelButtonTitle = "Cancel"
        picker.config.confirmButtonTitle = "Confirm"
        
        picker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        picker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        picker.config.confirmButtonColor = UIColor.black
        picker.config.cancelButtonColor = UIColor.black
        
    }
    
}


class ViewController: UIViewController {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "WELCOME TO GMPICKER"
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    
    let userGender: UITextView = {
        let gender = UITextView()
        gender.layer.cornerRadius = 6
        gender.layer.borderColor = UIColor.black.cgColor
        gender.layer.borderWidth = 0.5
        gender.clipsToBounds = true
        gender.textAlignment = .center
        gender.font = UIFont.systemFont(ofSize: 12)
        gender.textColor = UIColor.black
        gender.text = "User Gender"
        gender.isUserInteractionEnabled = true
        gender.isScrollEnabled = false
        gender.isEditable = false
        return gender
    }()
    
    let year: UITextView = {
        let year = UITextView()
        year.layer.cornerRadius = 6
        year.layer.borderColor = UIColor.black.cgColor
        year.layer.borderWidth = 0.5
        year.clipsToBounds = true
        year.textAlignment = .center
        year.font = UIFont.systemFont(ofSize: 12)
        year.textColor = UIColor.black
        year.text = "Annus Mirabilis"
        year.isUserInteractionEnabled = true
        year.isScrollEnabled = false
        year.isEditable = false
        return year
    }()
    
    let dateOfBirth: UITextView = {
        let dob = UITextView()
        dob.layer.cornerRadius = 6
        dob.layer.borderColor = UIColor.black.cgColor
        dob.layer.borderWidth = 0.5
        dob.clipsToBounds = true
        dob.textAlignment = .center
        dob.font = UIFont.systemFont(ofSize: 12)
        dob.textColor = UIColor.black
        dob.text = "Date of birth"
        dob.isUserInteractionEnabled = true
        dob.isScrollEnabled = false
        dob.isEditable = false
        return dob
    }()
    
    var picker = GMPicker()
    var isYearPicked = false
    
    var datePicker = GMDatePicker()
    var dateFormatter = DateFormatter()

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
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(textLabel)
        textLabel.frame = CGRect(x: 24, y: 160, width: self.view.frame.width - 24 - 24, height: 60)
        
        view.addSubview(userGender)
        userGender.frame = CGRect(x: 24, y: 250, width: self.view.frame.width - 24 - 24, height: 30)
        userGender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseGender)))
        
        view.addSubview(year)
        year.frame = CGRect(x: 24, y: 250 + 30 + 10, width: self.view.frame.width - 24 - 24, height: 30)
        year.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseYear)))
        
        view.addSubview(dateOfBirth)
        dateOfBirth.frame = CGRect(x: 24, y: 250 + 30 + 10 + 30 + 10, width: self.view.frame.width - 24 - 24, height: 30)
        dateOfBirth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseDOB)))
        
        setupPickerView()
        dateFormatter.dateFormat = "dd MM yyyy"
        setupDatePicker()
    }
}
