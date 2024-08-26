//
//  LoginVC.swift
//  UpShop
//
//  Created by Admin on 20/05/22.
//

import UIKit

class loginCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var valueButton : UIButton!
    @IBOutlet weak var accessoryButton: UIButton!
}

class LoginVC: UIViewController {

    @IBOutlet weak var loginTableView: UITableView!
    
    private var gradientLayer = CAGradientLayer()
    private var isSecureTextEntry = true
    private var userModelObj = UserModel()
    
    // MARK: - UIView LifeCycle Method-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        if userModelObj.email.isEmpty {
            showAlert(message: "Please enter email / phone number", controller: self)
        }
        
        if userModelObj.email.containsNumberOnly() && !(userModelObj.email.isValidMobileNumber()) {
            showAlert(message: "Please enter valid phone number", controller: self)
        }
        
        if (userModelObj.email.isAlphaNumeric || userModelObj.email.containsAlphabetsOnly()) && !(userModelObj.email.isValidEmail()) {
            showAlert(message: "Please enter valid email", controller: self)
        }
        
        if userModelObj.password.isEmpty {
            showAlert(message: "Please enter password", controller: self)
        } else {
            isValidate = true
        }
        
        return isValidate
    }
    
    // MARK: - UIButton Action Methods-
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isUserValidated() {
            
        }
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - UITable View DataSource and Delegate Methods-

extension LoginVC: UITableViewDataSource, UITableViewDelegate {
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
            cell.titleLabel.text = "Email / Phone Number"
            cell.valueTextField.returnKeyType = .next
            cell.valueTextField.text = userModelObj.email
            break
        case 1:
            cell.titleLabel.text = "Password"
            cell.valueTextField.returnKeyType = .done
            cell.valueTextField.text = userModelObj.password
            cell.valueTextField.isSecureTextEntry = isSecureTextEntry
            cell.accessoryButton.isHidden = false
            cell.accessoryButton.addTarget(self, action: #selector(accessoryButtonAction), for: .touchUpInside)
            break
        default: break
        }
        
        return cell
    }
    
    @objc func accessoryButtonAction(sender: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        loginTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

// MARK: - UITextField Delegate Methods-

extension LoginVC : UITextFieldDelegate {
                
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
            userModelObj.email = textField.text!
            break
        case 101:
            userModelObj.password = textField.text!
            break
        default:
            break
        }
    }
}
