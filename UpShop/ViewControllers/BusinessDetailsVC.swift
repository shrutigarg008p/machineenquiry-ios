//
//  BusinessDetailsVC.swift
//  UpShop
//
//  Created by Admin on 25/05/22.
//

import UIKit
import GoogleMaps
import CountryPicker

class WorkingDaysCell: UICollectionViewCell {
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class BusinessDetailsVC: UIViewController, CountryPickerDelegate {
    
    @IBOutlet weak var businessDetailsTableView: UITableView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var fromHoursTextField: UITextField!
    @IBOutlet weak var toHoursTextField: UITextField!
    @IBOutlet weak var workingDaysCollectionView: UICollectionView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodePickerView: CountryPicker!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    private var gradientLayer = CAGradientLayer()
    private var categoryList = ["Electrical", "Wires", "Plugs", "Automobiles", "Hydraulics", "Saftey Gears & Tools"]
    private var workingDaysList = [["title": "All", "isSelected": false], ["title": "Mon", "isSelected": false], ["title": "Tue", "isSelected": false], ["title": "Wed", "isSelected": false], ["title": "Thu", "isSelected": false], ["title": "Fri", "isSelected": false], ["title": "Sat", "isSelected": false], ["title": "Sun", "isSelected": false]]
    private var userModelObj = UserModel()
    
    // MARK: - UIView Life Cycle Methods-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeView.isHidden = true
        categoryView.isHidden = true
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
        let indexPath = IndexPath(row: 3, section: 0)
        guard let cell = businessDetailsTableView.cellForRow(at: indexPath) as? PhoneNumberCell else {
            return
        }
        
        userModelObj.countryCode = phoneCode
        cell.countryFlagImageView.image = flag
        cell.countryCodeTextField.text = phoneCode
    }
    
    // MARK: - UIButton Action Methods-
    
    @IBAction func browseButtonAction(_ sender: UIButton) {
        countryCodeView.isHidden = true
        categoryView.isHidden = true
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        countryCodeView.isHidden = true
        categoryView.isHidden = true
    }
    
    @IBAction func fromHoursButtonAction(_ sender: UIButton) {
        countryCodeView.isHidden = true
        categoryView.isHidden = true
    }
    
    @IBAction func toHoursButtonAction(_ sender: UIButton) {
        countryCodeView.isHidden = true
        categoryView.isHidden = true
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        countryCodeView.isHidden = true
        categoryView.isHidden = true
        businessDetailsTableView.reloadData()
    }
    
    @IBAction func categoryDoneButtonAction(_ sender: UIButton) {
        countryCodeView.isHidden = true
        categoryView.isHidden = true
        userModelObj.category = userModelObj.category.isEmpty ? categoryList[0] : userModelObj.category
        businessDetailsTableView.reloadData()
    }
    
}

// MARK: - UITable View DataSource and Delegate Methods-

extension BusinessDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: loginCell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! loginCell
        
        cell.accessoryButton.isHidden = true
        cell.valueButton.isHidden = true
        cell.valueTextField.tag = 100 + indexPath.row
        cell.accessoryButton.tag = 200 + indexPath.row
        cell.valueTextField.returnKeyType = .next
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Shop Name"
            cell.valueTextField.placeholder = "Enter Shop Name"
            cell.valueTextField.text = userModelObj.shopName
            break
        case 1:
            cell.titleLabel.text = "Owner Name"
            cell.valueTextField.placeholder = "Enter Owner Name"
            cell.valueTextField.text = userModelObj.ownerName
            break
        case 2:
            cell.titleLabel.text = "Email"
            cell.valueTextField.placeholder = "Enter your email address"
            cell.valueTextField.text = userModelObj.email
            break
        case 3:
            let phoneNumberCell: PhoneNumberCell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumberCell") as! PhoneNumberCell
            phoneNumberCell.titleLabel.text = "Phone"
            phoneNumberCell.phoneNumberTextField.text = userModelObj.phoneNumber
            phoneNumberCell.countryCodeTextField.text = userModelObj.countryCode.isEmpty ? "+91" : userModelObj.countryCode
            phoneNumberCell.phoneNumberTextField.placeholder = "Enter phone number"
            phoneNumberCell.phoneNumberTextField.tag = 100 + indexPath.row
            phoneNumberCell.countryCodeButton.addTarget(self, action: #selector(countryCodeSelection), for: .touchUpInside)
            return phoneNumberCell
        case 4:
            cell.titleLabel.text = "Additional Phone number"
            cell.valueTextField.placeholder = "Enter your additional phone number"
            cell.valueTextField.keyboardType = .phonePad
            cell.valueTextField.text = userModelObj.additionalPhoneNumber
            break
        case 5:
            cell.titleLabel.text = "Category"
            cell.valueTextField.placeholder = "Please select Category"
            cell.valueTextField.text = userModelObj.category
            cell.valueButton.isHidden = false
            cell.accessoryButton.isHidden = false
            cell.valueButton.addTarget(self, action: #selector(valueButtonAction), for: .touchUpInside)
            break
        case 6:
            cell.titleLabel.text = "Add a Shop Photo (Up to 5)"
            cell.valueTextField.placeholder = "Upload a photo"
            cell.valueTextField.text = ""
            break
        default: break
        }
        return cell
    }
    
    @objc func valueButtonAction(sender: UIButton) {
        countryCodeView.isHidden = true
        categoryView.isHidden = false
    }
    
    @objc func countryCodeSelection(sender: UIButton) {
        countryCodeView.isHidden = false
        categoryView.isHidden = true
        setCountryPicker()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

// MARK: - UIPickerView DataSource and Delegate Methods-

extension BusinessDetailsVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = categoryList[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        userModelObj.category = categoryList[row]
    }
    
}

// MARK: - UICollectionView DataSource and Delegate Methods-

extension BusinessDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workingDaysList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WorkingDaysCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkingDaysCell", for: indexPath) as! WorkingDaysCell
        let dict = workingDaysList[indexPath.item]
        cell.checkboxImageView.image = dict["isSelected"] as? Bool == true ? UIImage.init(named: "checked") : UIImage.init(named: "uncheck")
        cell.titleLabel.text = dict["title"] as? String ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.bounds.width / 4) - 20, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let day = workingDaysList[indexPath.item]
            if day["isSelected"] as? Bool == true {
                for index in 0..<workingDaysList.count {
                    var day = workingDaysList[index]
                    day["isSelected"] = false
                    workingDaysList.remove(at: index)
                    workingDaysList.insert(day, at: index)
                }
            }else {
                for index in 0..<workingDaysList.count {
                    var day = workingDaysList[index]
                    day["isSelected"] = true
                    workingDaysList.remove(at: index)
                    workingDaysList.insert(day, at: index)
                }
            }
        } else {
            var allDay = workingDaysList[0]
            var day = workingDaysList[indexPath.item]
            if day["isSelected"] as? Bool == true {
                day["isSelected"] = false
                allDay["isSelected"] = false
            }else {
                day["isSelected"] = true
                var selectDaysCount = 0
                for index in 0..<workingDaysList.count {
                    
                    if index != 0 {
                        let day = workingDaysList[index]
                        if day["isSelected"] as? Bool == true {
                            selectDaysCount = selectDaysCount + 1
                        }
                    }
                    
                }
                
                if selectDaysCount == 6 {
                    allDay["isSelected"] = true
                }

            }
            workingDaysList.remove(at: indexPath.item)
            workingDaysList.insert(day, at: indexPath.item)
            workingDaysList.remove(at: 0)
            workingDaysList.insert(allDay, at: 0)
        }
        workingDaysCollectionView.reloadData()
    }
    
}
