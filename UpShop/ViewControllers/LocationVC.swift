//
//  LocationVC.swift
//  UpShop
//
//  Created by Admin on 23/05/22.
//

import UIKit
import GoogleMaps
import CoreLocation

class LocationVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var googleMapView: GMSMapView!
    
    private var gradientLayer = CAGradientLayer()
    private let locationManager = CLLocationManager()
    
    // MARK: - UIView LifeCycle Methods-

    override func viewDidLoad() {
        super.viewDidLoad()
        locationConfig()
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
        gradientLayer.frame = headerView.bounds
        headerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Custom Methods-
    
    func locationConfig(){
        self.googleMapView.delegate = self
        googleMapView.setMinZoom(10, maxZoom: 100)
        self.googleMapView.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestLocationAuth() {
        
        locationManager.requestAlwaysAuthorization()
        //locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .denied: // Setting option: Never
                self.openAppSettings()
            break
            case .notDetermined: break
            case .authorizedWhenInUse:
                // While using the app
                locationManager.requestAlwaysAuthorization()
                locationManager.requestLocation()
            case .authorizedAlways:
                // Always allow
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            case .restricted: // Restricted by parental control
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func openAppSettings() {
        let settingText = "Yes"
        let cancelText = "No"
        let message = "Your GPS seems to be disabled, do you want to enable it?"
        
        let goToSettingsAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        goToSettingsAlert.addAction(UIAlertAction(title: settingText, style: .default, handler: { (action: UIAlertAction) in
            DispatchQueue.main.async {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                }
            }
        }))
        
        goToSettingsAlert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
        self.present(goToSettingsAlert, animated: true, completion: nil)
    }
                
    // MARK: - UIButton Action Methods-
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "PersonalDetailsVC") as! PersonalDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: - CLLocationManager Delegate Methods -

extension LocationVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        print(location.coordinate.latitude,location.coordinate.longitude)
        
        let locationObj = locations.last ?? CLLocation()
        let coord = locationObj.coordinate
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            self.googleMapView.isMyLocationEnabled = true
            self.googleMapView.settings.compassButton = true
            if let lat = googleMapView.myLocation?.coordinate.latitude,
               let lng = googleMapView.myLocation?.coordinate.longitude {
                
                let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 18)
                googleMapView.animate(to: camera)
            }
        }
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.requestLocationAuth()

            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        } else {
            
            print("Location services are not enabled")
            self.requestLocationAuth()
            
        }
        
    }
    
}
