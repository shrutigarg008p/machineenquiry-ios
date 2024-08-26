//
//  ForgotPasswordVC.swift
//  UpShop
//
//  Created by Admin on 23/05/22.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var forgotPasswordTableView: UITableView!
    
    private var gradientLayer = CAGradientLayer()
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
        
        if userModelObj.email.isEmpty {
            showAlert(message: "Please enter email / phone number", controller: self)
        }
        
        if userModelObj.email.containsNumberOnly() && !(userModelObj.email.isValidMobileNumber()) {
            showAlert(message: "Please enter valid phone number", controller: self)
        }
        
        if (userModelObj.email.isAlphaNumeric || userModelObj.email.containsAlphabetsOnly()) && !(userModelObj.email.isValidEmail()) {
            showAlert(message: "Please enter valid email", controller: self)
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
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

// MARK: - UITable View DataSource and Delegate Methods-

extension ForgotPasswordVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: loginCell = tableView.dequeueReusableCell(withIdentifier: "loginCell", for: indexPath) as! loginCell
        
        cell.accessoryButton.isHidden = true
        cell.valueButton.isHidden = true
        cell.titleLabel.text = "Email / Phone Number"
        cell.valueTextField.returnKeyType = .done
        cell.valueTextField.text = userModelObj.email
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

// MARK: - UITextField Delegate Methods-

extension ForgotPasswordVC : UITextFieldDelegate {
                    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userModelObj.email = textField.text!
    }
}
