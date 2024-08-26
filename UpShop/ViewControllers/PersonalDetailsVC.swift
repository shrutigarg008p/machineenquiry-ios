//
//  PersonalDetailsVC.swift
//  UpShop
//
//  Created by Admin on 25/05/22.
//

import UIKit
import CountryPicker

class PhoneNumberCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
}

class PersonalDetailsVC: UIViewController, CountryPickerDelegate {
    
    @IBOutlet weak var personalDetailsTableView: UITableView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodePickerView: CountryPicker!
    
    private var gradientLayer = CAGradientLayer()
    private var isNewPasswordSecureTextEntry = true
    private var isConfirmPasswordSecureTextEntry = true
    private var userModelObj = UserModel()
    
    // MARK: - UIView Life Cycle Methods-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ _animated: Bool) {
        super.viewWillAppear(_animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        let topColor = UIColor(red: 13.0/255.0, green: 218.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 0.0/255.0, green: 116.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setCountryPicker() {
        //get current country
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        countryCodePickerView.countryPickerDelegate = self
        countryCodePickerView.showPhoneNumbers = true
        countryCodePickerView.setCountry(code!)
    }
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        let indexPath = IndexPath(row: 2, section: 0)
        guard let cell = personalDetailsTableView.cellForRow(at: indexPath) as? PhoneNumberCell else {
            return
        }
        
        userModelObj.countryCode = phoneCode
        cell.countryFlagImageView.image = flag
        cell.countryCodeTextField.text = phoneCode
    }
    
    func isUserValidated() -> Bool {
        var isValidate = false
        
        if userModelObj.name.isEmpty {
            showAlert(message: "Please enter name", controller: self)
        }
        
        if userModelObj.email.isEmpty {
            showAlert(message: "Please enter email", controller: self)
        }
        
        if !(userModelObj.email.isValidEmail()) {
            showAlert(message: "Please enter valid email", controller: self)
        }
        
//        if userModelObj.countryCode.isEmpty {
//            showAlert(message: "Please select country code", controller: self)
//        }
        
        if userModelObj.phoneNumber.isEmpty {
            showAlert(message: "Please enter phone number", controller: self)
        }
        
        if !(userModelObj.phoneNumber.isValidMobileNumber()) {
            showAlert(message: "Please enter valid phone number", controller: self)
        }
        
        if userModelObj.password.isEmpty {
            showAlert(message: "Please enter new password", controller: self)
        }
        
        if userModelObj.confirmPassword.isEmpty {
            showAlert(message: "Please re-enter password", controller: self)
        }
        
        if userModelObj.password != userModelObj.confirmPassword {
            showAlert(message: "Passwords did not match.", controller: self)
        }else {
            isValidate = true
        }
        
        return isValidate
    }
    
    // MARK: - UIButton Action Methods-
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isUserValidated() {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "BusinessDetailsVC") as! BusinessDetailsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        countryCodeView.isHidden = true
        personalDetailsTableView.reloadData()
    }
    
}

// MARK: - UITable View DataSource and Delegate Methods-

extension PersonalDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: loginCell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! loginCell
        
        cell.accessoryButton.isHidden = true
        cell.valueButton.isHidden = true
        cell.valueTextField.tag = 100 + indexPath.row
        cell.accessoryButton.tag = 200 + indexPath.row
        cell.valueTextField.returnKeyType = .next
        cell.valueTextField.delegate = self
        cell.valueTextField.isSecureTextEntry = false
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Name"
            cell.valueTextField.text = userModelObj.name
            break
        case 1:
            cell.titleLabel.text = "Email"
            cell.valueTextField.text = userModelObj.email
            break
        case 2:
            let phoneNumberCell: PhoneNumberCell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumberCell") as! PhoneNumberCell
            phoneNumberCell.titleLabel.text = "Phone"
            phoneNumberCell.phoneNumberTextField.delegate = self
            phoneNumberCell.countryCodeTextField.text = userModelObj.countryCode.isEmpty ? "+91" : userModelObj.countryCode
            phoneNumberCell.phoneNumberTextField.text = userModelObj.phoneNumber
            phoneNumberCell.phoneNumberTextField.tag = 100 + indexPath.row
            phoneNumberCell.countryCodeButton.addTarget(self, action: #selector(countryCodeSelection), for: .touchUpInside)
            return phoneNumberCell
        case 3:
            cell.titleLabel.text = "Password"
            cell.valueTextField.returnKeyType = .next
            cell.valueTextField.text = userModelObj.password
            cell.valueTextField.isSecureTextEntry = isNewPasswordSecureTextEntry
            cell.accessoryButton.isHidden = false
            cell.accessoryButton.addTarget(self, action: #selector(accessoryButtonAction), for: .touchUpInside)
            break
        case 4:
            cell.titleLabel.text = "Re-Enter Password"
            cell.valueTextField.returnKeyType = .done
            cell.valueTextField.text = userModelObj.confirmPassword
            cell.valueTextField.isSecureTextEntry = isConfirmPasswordSecureTextEntry
            cell.accessoryButton.isHidden = false
            cell.accessoryButton.addTarget(self, action: #selector(accessoryButtonAction), for: .touchUpInside)
            break
        default: break
        }
        return cell
    }
    
    @objc func accessoryButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        if (sender.tag - 200) == 3 {
            isNewPasswordSecureTextEntry = !isNewPasswordSecureTextEntry
        }else {
            isConfirmPasswordSecureTextEntry = !isConfirmPasswordSecureTextEntry
        }
        
        personalDetailsTableView.reloadData()
    }
    
    @objc func countryCodeSelection(sender: UIButton) {
        self.view.endEditing(true)
        countryCodeView.isHidden = false
        setCountryPicker()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

// MARK: - UITextField Delegate Methods-

extension PersonalDetailsVC : UITextFieldDelegate {
                
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.returnKeyType == UIReturnKeyType.next){
            let tf = getViewWithTag(tag: (textField.tag + 1), view: self.view) as! UITextField
            tf.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 100:
            userModelObj.name = textField.text!
            break
        case 101:
            userModelObj.email = textField.text!
            break
        case 102:
            userModelObj.phoneNumber = textField.text!
            break
        case 103:
            userModelObj.password = textField.text!
            break
        case 104:
            userModelObj.confirmPassword = textField.text!
            break
        default:
            break
        }
    }
}
