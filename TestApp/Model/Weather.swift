//
//  Weather.swift
//  TestApp
//
//  Created by Alina on 12/6/17.
//  Copyright © 2017 Alina. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary: String
    let icon: String
    let temperature: Double
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        
    }
    
    static let basePath = "https://api.darksky.net/forecast/d81c691216c41c1a5f8ef24e2195e800/"
    
    static func forecast (withLocation location: CLLocationCoordinate2D, completion: @escaping ([Weather]?, String) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var forecastArray: [Weather] = []
            var errorMessage: String = ""
            
            if let sessionError = error {
                print(sessionError.localizedDescription)
            }
            
            if let sessionResponse = response as? HTTPURLResponse {
                switch sessionResponse.statusCode {
                    case HTTPStatusCodes.BadRequest.rawValue:
                        errorMessage = "Invalid query"
                    case HTTPStatusCodes.Unauthorized.rawValue:
                        errorMessage = "Not authorized"
                    case HTTPStatusCodes.NotFound.rawValue:
                        errorMessage = "Not fount"
                    default:
                        errorMessage = ""
                }
            }
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                        
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray, errorMessage)
            }
        }
        task.resume()
    }
    
}
