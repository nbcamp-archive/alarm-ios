//
//  weatherIcon.swift
//  Alarm
//
//  Created by kiakim on 2023/10/02.
//

import Foundation
import UIKit



enum Temp {
    
    init?(initailValue: Int){
        switch initailValue {
        case 200...232:
            self = .thunderstorm //뇌우
        case 300...321:
            self = .drizzle //가랑비
        case 500...531:
            self = .rain
        case 600...622:
            self = .snow
        case 701...781:
            self = .atmosphere //대기질
        case 800:
            self = .clear
        case 801...804:
            self = .clouds
        default:
            return nil
        }
    }
    
    case thunderstorm
    case drizzle
    case rain
    case snow
    case atmosphere
    case clear
    case clouds
    

}

extension WeatherViewController{
      
    func changeIconAndBG(){
        let yoroke = Temp(initailValue: weatherConditon)

        
        if let tempCase = yoroke{
            switch tempCase {
            case .snow:
                testBox.backgroundColor = UIColor.red
                weatherImage.image = UIImage(named: "snow")
            case .clear:
                testBox.backgroundColor = UIColor.orange
                weatherImage.image = UIImage(named: "rain")

            case .thunderstorm: //뇌우
                testBox.backgroundColor = UIColor.yellow
                weatherImage.image = UIImage(named: "thunderstorm")
            case .drizzle: //가랑비
                testBox.backgroundColor = UIColor.green
                weatherImage.image = UIImage(named: "drizzle")
            case .rain:
                testBox.backgroundColor = UIColor.blue
                weatherImage.image = UIImage(named: "rain")
            case .atmosphere: //대기질
                testBox.backgroundColor = UIColor.purple
                weatherImage.image = UIImage(named: "atmosphere")
            case .clouds:
                testBox.backgroundColor = UIColor.white
                weatherImage.image = UIImage(named: "clouds")
               
            }
        } else {
            testBox.backgroundColor = UIColor.gray
        }
    }
}





