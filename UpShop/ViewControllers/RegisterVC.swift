//
//  RegisterVC.swift
//  UpShop
//
//  Created by Admin on 23/05/22.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var registerTableView: UITableView!
    @IBOutlet weak var userRoleView: UIView!
    @IBOutlet weak var userRolePickerView: UIPickerView!
    
    private var gradientLayer = CAGradientLayer()
    private var userModelObj = UserModel()

    // MARK: - UIView LifeCycle Methods-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRoleView.isHidden = true
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
    
    func isUserValidated() -> Bool {
        var isValidate = false
        
        if userModelObj.userRole == "Select Type" {
            showAlert(message: "Please select User Role", controller: self)
        }
        
        if userModelObj.email.isEmpty {
            showAlert(message: "Please enter email / phone number", controller: self)
        }
        
        if userModelObj.email.containsNumberOnly() && !(userModelObj.email.isValidMobileNumber()) {
            showAlert(message: "Please enter valid phone number", controller: self)
        }
        
        if (userModelObj.email.isAlphaNumeric || userModelObj.email.containsAlphabetsOnly()) && !(userModelObj.email.isValidEmail()) {
            showAlert(message: "Please enter valid email", controller: self)
        } else {
            isValidate = true
        }
        
        return isValidate
    }
    
    // MARK: - UIButton Action Methods-
    
    @IBAction func sendConfirmationCodeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isUserValidated() {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        userRoleView.isHidden = true
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        userRoleView.isHidden = true
        userModelObj.userRole = userModelObj.userRole == "Select Type" ? "Customer" : userModelObj.userRole
        registerTableView.reloadData()
    }

}

// MARK: - UITable View DataSource and Delegate Methods-

extension RegisterVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: loginCell = tableView.dequeueReusableCell(withIdentifier: "loginCell", for: indexPath) as! loginCell
        
        cell.accessoryButton.isHidden = true
        cell.valueButton.isHidden = true
        cell.valueTextField.tag = 100 + indexPath.row
        cell.valueTextField.delegate = self
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "User Type"
            cell.valueButton.isHidden = false
            cell.accessoryButton.isHidden = false
            cell.valueButton.addTarget(self, action: #selector(valueButtonAction), for: .touchUpInside)
            cell.valueTextField.text = userModelObj.userRole
            break
        case 1:
            cell.titleLabel.text = "Email / Phone Number"
            cell.valueTextField.returnKeyType = .done
            cell.valueTextField.text = userModelObj.email
            break
        default: break
        }
        
        return cell
    }
    
    @objc func valueButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        userRoleView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

// MARK: - UIPickerView DataSource and Delegate Methods-

extension RegisterVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        
        if row == 0 {
            pickerLabel?.text = "Customer"
        } else {
            pickerLabel?.text = "Seller"
        }

        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if row == 0 {
            userModelObj.userRole = "Customer"
        }else {
            userModelObj.userRole = "Seller"
        }
    }
    
}

// MARK: - UITextField Delegate Methods-

extension RegisterVC : UITextFieldDelegate {
                
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
            userModelObj.userRole = textField.text!
            break
        case 101:
            userModelObj.email = textField.text!
            break
        default:
            break
        }
    }
}
