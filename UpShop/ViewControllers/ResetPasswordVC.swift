//
//  ResetPasswordVC.swift
//  UpShop
//
//  Created by Admin on 23/05/22.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var resetPasswordTableView: UITableView!
    
    private var gradientLayer = CAGradientLayer()
    private var isNewPasswordSecureTextEntry = true
    private var isConfirmPasswordSecureTextEntry = true
    private var userModelObj = UserModel()
    
    // MARK: - UIView LifeCycle Methods-
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isUserValidated() {
            for controller in (self.navigationController?.viewControllers)! {
                if controller is LoginVC {
                    self.navigationController?.popToViewController(controller, animated: false)
                }
            }
        }
    }

}

// MARK: - UITable View DataSource and Delegate Methods-

extension ResetPasswordVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: loginCell = tableView.dequeueReusableCell(withIdentifier: "loginCell", for: indexPath) as! loginCell
        
        cell.accessoryButton.isHidden = false
        cell.valueButton.isHidden = true
        cell.valueTextField.tag = 100 + indexPath.row
        cell.accessoryButton.tag = 200 + indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "New Password"
            cell.valueTextField.returnKeyType = .next
            cell.valueTextField.text = userModelObj.password
            cell.valueTextField.isSecureTextEntry = isNewPasswordSecureTextEntry
            cell.accessoryButton.addTarget(self, action: #selector(accessoryButtonAction), for: .touchUpInside)
            break
        case 1:
            cell.titleLabel.text = "Re-Enter New Password"
            cell.valueTextField.returnKeyType = .done
            cell.valueTextField.text = userModelObj.confirmPassword
            cell.valueTextField.isSecureTextEntry = isConfirmPasswordSecureTextEntry
            cell.accessoryButton.addTarget(self, action: #selector(accessoryButtonAction), for: .touchUpInside)
            break
        default: break
        }
        
        return cell
    }
    
    @objc func accessoryButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        if (sender.tag - 200) == 0 {
            isNewPasswordSecureTextEntry = !isNewPasswordSecureTextEntry
        }else {
            isConfirmPasswordSecureTextEntry = !isConfirmPasswordSecureTextEntry
        }
        
        resetPasswordTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

// MARK: - UITextField Delegate Methods-

extension ResetPasswordVC : UITextFieldDelegate {
                
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
            userModelObj.password = textField.text!
            break
        case 101:
            userModelObj.confirmPassword = textField.text!
            break
        default:
            break
        }
    }
}
