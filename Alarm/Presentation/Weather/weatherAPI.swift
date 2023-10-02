//
//  WeatherAPI.swift
//  Alarm
//
//  Created by kiakim on 2023/09/27.
//

import Foundation
import Alamofire

extension WeatherViewController {
    
    
    //컴플리션(클로져) 추가 필요
    func callWeather(){
        AF.request(openWeatherAPI)
                 .responseJSON { response in
                switch response.result {
                case .success(let json):
                    
                    if let jsonDict = json as? [String: Any],
                       let weatherArray = jsonDict["weather"] as? [[String: Any]],
                       let mainDict = jsonDict["main"] as? [String: Any],
                       let conditionCode = weatherArray.first?["id"] as? Int,
                        let mainWeather = weatherArray.first?["main"] as? String,
                       let temp = mainDict["temp"] as? Double,
                       let tempMax = mainDict["temp_max"] as? Double,
                       let tempMin = mainDict["temp_min"] as? Double,
                       let windDict = jsonDict["wind"] as?[String: Any],
                       let windSpeed = windDict["speed"] as? Double,
                       let humidity = mainDict["humidity"] as? Int,
                       let cityName = jsonDict["name"] as? String
                        
                    {
                        DispatchQueue.main.async {
                            self.testCode.text = String("\(conditionCode)")
                            self.weatherConditon = conditionCode
//                            self.weatherConditon = 800
                            self.firstSwitch()
                            self.cityNameLabel.text = cityName
                            self.weatherTodayLabel.text = mainWeather
                            self.tempTodayLabel.text = String(format: " %.f", temp)
                            self.detailInfoBox.tempMax.text = String(format:"Max: %.1f°C" ,tempMax)
                            self.detailInfoBox.tempMin.text = String(format:"Min: %.1f°C" ,tempMin)
                            
                            self.detailInfoBox.windData.text = String(format:"\(windSpeed)m/s" )
                            self.detailInfoBox.humidityData.text = String(format:"\(humidity) %%" )
                            
                            
                            
                        }
                        
                    } else {
                        
                        
                        print("날씨안나옴! ")
                        
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
}
