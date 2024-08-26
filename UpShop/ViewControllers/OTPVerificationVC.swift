//
//  OTPVerificationVC.swift
//  UpShop
//
//  Created by Admin on 23/05/22.
//

import UIKit

class OTPVerificationVC: UIViewController {
    
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var fifthTextField: UITextField!
    
    private var gradientLayer = CAGradientLayer()
    private var timer = Timer()
    private var timerValue = 90
    
    // MARK: - UIView LifeCycle Methods-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateOTPTimer)), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ _animated: Bool) {
        super.viewWillAppear(_animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.timer.invalidate()
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
    
    // MARK: - Custom Methods-
    
    @objc func updateOTPTimer() {
        if timerValue < 1 {
            timer.invalidate()
            timerButton.setTitle("00:00 sec", for: .normal)
            self.navigationController?.popViewController(animated: true)
        } else {
            timerValue -= 1
            timerButton.setTitle(OTPTimeString(time: TimeInterval(timerValue)), for: .normal)
        }
    }

    func OTPTimeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d sec", minutes, seconds)
    }
        
    // MARK: - UIButton Action Methods-
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        timerValue = 90
    }
    
    @IBAction func verifyButtonAction(_ sender: UIButton) {
        
        guard let firstDigit = firstTextField.text, let secDigit = secTextField.text, let thirdDigit = thirdTextField.text, let fourthDigit = fourthTextField.text, let fifthDigit = fifthTextField.text else {
            showAlert(message: "Please enter OTP", controller: self)
            return
        }
        
        if firstDigit.isEmpty || secDigit.isEmpty || thirdDigit.isEmpty || fourthDigit.isEmpty || fifthDigit.isEmpty {
            showAlert(message: "Please enter OTP", controller: self)
        }
        
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "PermissionVC") as! PermissionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension OTPVerificationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        if newString.count == 1 {
            textFieldShouldReturnSingle(textField, newString : newString)
            return false
        }
        return true
    }
    
    func textFieldShouldReturnSingle(_ textField: UITextField, newString : String) {
        let nextTag: Int = textField.tag + 1
        textField.text = newString
        let nextResponder: UIResponder? = textField.superview?.viewWithTag(nextTag)
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            // call your method
        }
    }
}
