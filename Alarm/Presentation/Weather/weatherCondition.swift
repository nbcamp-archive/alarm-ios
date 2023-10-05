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
        
//        let bringAnimationBG = CAAnimationGradientLayer()
        
        let yoroke = Temp(initailValue: weatherConditon)
        if let tempCase = yoroke{
            switch tempCase {
                
              
            case .snow:
                weatherImage.image = UIImage(named: "snow")
                
            case .clear:
                weatherImage.image = UIImage(named: "clear")
//                bringAnimationBG.animateGradient(hex: "d62828") //red
                  HEX = "ffd60a" //yellow
                print("Hex1",HEX)
//                let gradient = CAAnimationGradientLayer()
//                gradient.animateGradient(hex: HEX)
                //hex 값 print 찍어보기
                
                
                //hex값을 넣어줌
                
//                backgroundView.layer.sublayers?.first as? CAAnimationGradientLayer
//                if let gradientLayer = backgroundView.layer.sublayers? .first as? CAAnimationGradientLayer{
//                    gradientLayer.cusotmHex = "FFFFF"
//                    print("Hex값 바꼇음", gradientLayer.cusotmHex)
//
//
//                }
                
                
                
                
                
            case .thunderstorm: //뇌우
                weatherImage.image = UIImage(named: "thunderstorm")
                HEX = "023047" //navi
            case .drizzle: //가랑비
                weatherImage.image = UIImage(named: "drizzle")
            case .rain:
                weatherImage.image = UIImage(named: "rain")
                //                animationLayer.cusotmHex = "80ed99"
                //                animationLayer.animateGradient()
                //                print("배경 Red!", animationLayer.cusotmHex)
            case .atmosphere:
                weatherImage.image = UIImage(named: "atmosphere")
            case .clouds:
                weatherImage.image = UIImage(named: "clouds")
            }
        } else {
            print("아이콘 없다 ... ")
        }
        
    }
}





