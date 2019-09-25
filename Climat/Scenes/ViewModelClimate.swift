//
//  ViewModelClimate.swift
//  Climat
//
//  Created by mohamed hashem on 8/26/19.
//  Copyright © 2019 mohamed hashem. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import Moya
import SwiftyJSON

protocol LocationStatus {
    func getLocationStatus(status: ServiceStatus?)
    func getWitherData(Wither: Climat?)
}

class ClimatViewModel : NSObject, CLLocationManagerDelegate {
    
    private let locationServiceManager = LocationServiceManager()
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    var locationDeleget: LocationStatus?
    let provider = MoyaProvider<Wither>()
    let locationManger = CLLocationManager()
    var climatModel = Climat()
    
    override init() {
        super.init()
        locationManger.delegate = self
        locationManger.requestAlwaysAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManger.startUpdatingLocation()
        locationManger.allowsBackgroundLocationUpdates = true
       
    }
    
    func loadLocationServuces() {
        locationServiceManager
            .stateSubject
            .asObserver()
            .distinctUntilChanged()
            .subscribe(onNext: { (ServiceStatus) in
                self.locationDeleget?.getLocationStatus(status: ServiceStatus)
            }).disposed(by: disposeBag)
    }
    
     func loadWither(Latitude: Float, longitude: Float) {
        provider.request(.wither(Latitude: Latitude, longitude: longitude)){  [weak self] Result in
            guard self != nil else { return }
            switch Result {
            case .success(let response):
                do {
                    let dataWither: JSON = try JSON(data: response.data)
                    print(dataWither)
                    self?.updateWeatherData(json : dataWither)
                } catch {
                    print("faild to convert data")
                }
            case .failure:
                print("faild url")
            }
        }
    }
    
     func loadWitherCity(city: String) {
        provider.request(.WitherCity(q: city)){  [weak self] Result in
            guard self != nil else { return }
            switch Result {
            case .success(let response):
                do {
                    let dataWither: JSON = try JSON(data: response.data)
                    print(dataWither)
                    self?.updateWeatherData(json : dataWither)
                } catch {
                    print("faild to convert data")
                }
            case .failure:
                print("faild url")
            }
        }
    }
    
    fileprivate func updateWeatherData(json : JSON){
        if let tempResult = json["main"]["temp"].double {
            climatModel.temperature = Int(tempResult - 273.15)
            climatModel.city = json["name"].stringValue
            climatModel.condition = json["weather"][0]["id"].intValue
            climatModel.weatherIconName = climatModel.updateWeatherIcon(condition: climatModel.condition!)
            
            climatModel.speed = json["wind"]["speed"].stringValue
            climatModel.deg = json["wind"]["deg"].stringValue
            
            climatModel.sunset = json["sys"]["sunset"].stringValue
            climatModel.sunrise = json["sys"]["sunrise"].stringValue
            
            locationDeleget?.getWitherData(Wither: climatModel)
            
            CashingData.share.sava(data: climatModel)
        } else {
            locationDeleget?.getWitherData(Wither: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            
            climatModel.latitude = Float(location.coordinate.latitude)
            climatModel.longitude = Float(location.coordinate.longitude)
            climatModel.coordinate  = location.coordinate
            
            loadWither(Latitude: Float(location.coordinate.latitude),
                       longitude: Float(location.coordinate.longitude))
            
            CashingData.share.sava(data: climatModel)
        }
    }
    
}
