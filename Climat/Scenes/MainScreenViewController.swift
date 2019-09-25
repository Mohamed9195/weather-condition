//
//  MainScreenViewController.swift
//  Climat
//
//  Created by mohamed hashem on 8/26/19.
//  Copyright © 2019 mohamed hashem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NotificationCenter
import RxCocoa
import RxSwift

class MainScreenViewController: UIViewController, LocationStatus {
    
    @IBOutlet fileprivate weak var cityNameTextField: UITextField!
    @IBOutlet fileprivate weak var tempLabel: UILabel!
    @IBOutlet fileprivate weak var imageTemp: UIImageView!
    @IBOutlet fileprivate weak var cityName: UILabel!
    
    let dispose: DisposeBag = DisposeBag()
    var MainModel: Climat?
    
    var viewModel: ClimatViewModel = ClimatViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.locationDeleget = self
        viewModel.loadLocationServuces()
        cityNameTextField.rx.controlEvent(.editingDidEnd).subscribe { (Data) in
            self.viewModel.loadWitherCity(city: self.cityNameTextField.text ?? "")
            print(self.cityNameTextField.text ?? "")
        }.disposed(by: dispose)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(openMap))
        swipeLeft.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
//        
//        let swiperight = UISwipeGestureRecognizer(target: self,
//                                                 action: #selector(openSavePlaces))
//        swiperight.direction = .right
//        self.view.addGestureRecognizer(swiperight)
        
    }
    
    @objc private func openMap() {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
//    @objc private func openSavePlaces() {
//        performSegue(withIdentifier: "goToTable", sender: self)
//    }
    
    func getLocationStatus(status: ServiceStatus?) {
        guard status != nil, status != .enabled, status != .unknown else { return }
        
        let alert = Alert(title: "Location", message: "We need your location to get temperature please open location services").addCancelAction(title: "Cancel").add(action: UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.openSettingOfApp()
        }))
        DispatchQueue.main.async {
            alert.show(in: self)
        }
    }
    
   fileprivate func openSettingOfApp() {
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                } else {
                    UIApplication.shared.openURL(settingsUrl as URL)
                }
            }
        }
    }
    
    func getWitherData(Wither: Climat?) {
        guard Wither != nil, let wither = Wither else { return }
        MainModel = Wither
        DispatchQueue.main.async {
            self.cityName.text = wither.city
            self.tempLabel.text = String(wither.temperature ?? 0)  + "°c"
            self.imageTemp.image = UIImage(named: (wither.weatherIconName)!)
//            self.allData.text = "wind Degree: \(wither.deg!)  \n wind Speed;: \(wither.speed!)  \n  sunrise: \(wither.sunrise!) \n sunset \(wither.sunset!)"
        }
    }
    
    @IBAction func getCurrentLocationTemp(_ sender: Any) {
        guard MainModel != nil, MainModel?.longitude != nil,MainModel?.latitude != nil  else {
            return
        }
        viewModel.loadWither(Latitude: MainModel!.latitude!, longitude: MainModel!.longitude!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMap" {
            let vc = segue.destination as! MapViewController
            vc.Model = CashingData.share.read()
        }
    }
}

extension MainScreenViewController {
   
}

extension Notification.Name {
    static let peru = Notification.Name("peru")
}
