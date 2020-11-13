//
//  Login.swift
//  Code_structure_with_login
//
//  Created by vishal lakum on 13/11/20.
//  Copyright © 2020 vishal lakum. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class Login: UIViewController {
    @IBOutlet weak var svMain: UIScrollView!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField! {
        didSet {
            txtPassword.delegate = self
        }
    }

    @IBOutlet weak var formView: UIView!
    
    var userDetails = UserModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFileds()
        formView.backgroundColor = UIColor.init(named: "primaryColor")

        //keyboard mangement
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    // MARK: - keyboard mangement
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            svMain.contentInset = .zero
        } else {
            svMain.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        svMain.scrollIndicatorInsets = svMain.contentInset
    }

    // MARK: - Ui Setup

    func setTextFileds() {
        UITextField.connectAllTxtFieldFields(txtfields: [txtEmail, txtPassword])
        txtEmail.maxLength = 50
        txtEmail.textColor = UIColor.init(named: "buttonColor")
        txtPassword.maxLength = 128
        txtPassword.textColor = UIColor.init(named: "buttonColor")
    }
    
    // MARK: - Ui validation

    func checkBlack() -> Bool  {
        var flag = true
        if txtPassword.text == "" {
            txtPassword.errorMessage = " "
            txtPassword.becomeFirstResponder()
            flag = false
        }
        
        if txtEmail.text == "" {
            txtEmail.errorMessage = " "
            txtEmail.becomeFirstResponder()
            flag = false
        }
        return self.validateInput() && flag
    }
    
    func validateInput() -> Bool {
        var flag = true
        if !txtEmail.hasValidEmail && txtEmail.text != "" {
            txtEmail.errorMessage = "Please enter valid email."
            txtEmail.becomeFirstResponder()
            flag = false
        }
        return flag
    }

    @IBAction func btnLoginTapped(_ sender: UIButton) {
        if self.checkBlack() {
            //do stuff here
            self.callGetProfileDetailsWebService()
        }
    }
}

extension Login {
    //MARK:-  Web service call
    func callGetProfileDetailsWebService() {
        userDetails.getOrderDetails(ById: 0, success_block: {(model) in
            
            if (model.null == nil){
                if model["success"].boolValue {
                    
                    //cast whole response to model at once
                    self.userDetails = UserModel.init(fromJson: model)
                    
                    //update any user defaults
                    Utility.userToken = model["token"].stringValue
                }
                else{
                    
                    //showing error message from server
                    showValidationErrorAlert(msg: model["message"].stringValue) {
                    }
                }
            }
        }, failur_block: {(error) in
            if error != nil
            {
                //showing error message from alamofire
                showValidationErrorAlert(msg: error?.localizedDescription ?? "failed") {
                }
            }
        })
    }
}
extension Login : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txt = textField as! SkyFloatingLabelTextField
        txt.errorMessage = ""
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}
