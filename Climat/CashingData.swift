//
//  CashingData.swift
//  Climat
//
//  Created by mohamed hashem on 9/18/19.
//  Copyright © 2019 mohamed hashem. All rights reserved.
//

import Foundation
import CoreLocation

class CashingData {
    static var share = CashingData()
    let dataCashed = UserDefaults.standard
    var dataArray: [CLLocationDegrees] = []
    
     func sava(data: Climat) {
        if data.coordinate != nil {
            dataArray.append(data.coordinate!.latitude)
            dataArray.append(data.coordinate!.longitude)
            
            dataCashed.set(dataArray, forKey: "CimatData")
        }
    }
    
     func read() -> [CLLocationDegrees]? {
        return dataCashed.array(forKey: "CimatData") as? [CLLocationDegrees]
    }
    
}
