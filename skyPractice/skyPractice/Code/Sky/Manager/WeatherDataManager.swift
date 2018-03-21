//
//  WeatherDataManager.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknown
}


final class WeatherDataManager {
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
    
    let baseURL: URL
    let urlSession: URLSession
    
    static let shared = WeatherDataManager.init(baseURL: API.authenticatedURL, urlSession:URLSession.shared)
    
    // init
    init(baseURL: URL, urlSession: URLSession) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    
    // 请求天气数据
    func weatherDataAt(latitude: Double, longitude: Double, completion: @escaping CompletionHandler)
    {
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        self.urlSession.dataTask(with: request) { (data, response, error) in
            self.didFinishGettingWeatherData(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    
    // 处理天气数据
    func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler)
    {
        if let _ = error
        {
            completion(nil, DataManagerError.failedRequest)
        }
        else if let data = data, let response = response as? HTTPURLResponse
        {
            if response.statusCode == 200
            {
                do
                {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(weatherData, nil)
                }
                catch
                {
                    completion(nil, DataManagerError.invalidResponse)
                }
            }
            else
            {
                completion(nil, DataManagerError.failedRequest)
            }
        }
        else
        {
            completion(nil, DataManagerError.unknown)
        }
    }
}


