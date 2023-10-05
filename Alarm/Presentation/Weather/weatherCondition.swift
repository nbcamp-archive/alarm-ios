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
            case .thunderstorm: //뇌우
                weatherImage.image = UIImage(named: "thunderstorm")
                HEX = "031d44" //navi
            case .drizzle: //가랑비
                weatherImage.image = UIImage(named: "drizzle")
                HEX = "5390d9" //blue
            case .rain:
                weatherImage.image = UIImage(named: "rain")
                HEX = "5390d9" //blue
            case .snow:
                weatherImage.image = UIImage(named: "snow")
                HEX = "64b878" //green
            case .atmosphere:
                weatherImage.image = UIImage(named: "atmosphere")
                HEX = "94d2bd" //grayEmerald
            case .clear:
                weatherImage.image = UIImage(named: "clear")
                HEX = "4895ef" // skyblue
            case .clouds:
                weatherImage.image = UIImage(named: "clouds")
                HEX = "5390d9" //blue
            }
        } else {
            print("No Icon")
        }
    }
}




