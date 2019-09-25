//
//  ApiConnection.swift
//  Climat
//
//  Created by mohamed hashem on 9/2/19.
//  Copyright © 2019 mohamed hashem. All rights reserved.
//

import Foundation
import Moya

public enum Wither {
    
    static fileprivate  let  Weather_Url = "http://api.openweathermap.org/data/2.5/weather"
    static fileprivate  let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    static var longitude: String?
    static var Latitude: String?
    
    case wither(Latitude: Float,longitude: Float)
    case WitherCity(q: String)
}

extension Wither: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    
    public var baseURL: URL {
        return URL(string: Wither.Weather_Url)!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        switch self {
        case .wither, .WitherCity:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
       
        case .wither(let Latitude, let longitude):
             return .requestParameters( parameters: ["lat": Latitude, "lon": longitude, "appid": Wither.APP_ID], encoding: URLEncoding.queryString)
        case .WitherCity(let q):
             return .requestParameters( parameters: ["q": q, "appid": Wither.APP_ID], encoding: URLEncoding.queryString)
        }
    }
}
