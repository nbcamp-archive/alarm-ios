//
//  WeatherViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit
import SnapKit

class WeatherViewController: BaseUIViewController {
    
    let openWeatherAPI = "https://api.openweathermap.org/data/2.5/weather?q=seoul&APPID=f39b81a80e0097ae770b65082a10db12&units=metric"
    
    let cityNameLabel : UILabel = {
        let label = UILabel()
        label.text = "cityNameLabel"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    let weatherLabel : UILabel = {
        let label = UILabel()
        label.text = "weatherLabel"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        return label
    }()
    
    let weatherTitle: UILabel = {
        let label = UILabel()
        label.text = "오늘의 날씨"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    
    let bottomBox: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    var tempMax: UILabel = {
        let label = UILabel()
//        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
       return label
    }()
    
    var tempMin: UILabel = {
        let label = UILabel()
//        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
       return label
    }()
    
    
    var rainFall: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var windSpeed: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    var humidity: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    weak var coordinator: WeatherViewCoordinator?
    
    override func setTitle() {
        title = "날씨"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        callWeather()
    }
    
    
    func setupUI(){
        self.view.addSubview(cityNameLabel)
        self.view.addSubview(weatherLabel)
        self.view.addSubview(weatherTitle)
        self.view.addSubview(bottomBox)
        bottomBox.addArrangedSubview(tempMax)
        bottomBox.addArrangedSubview(tempMin)
        bottomBox.addArrangedSubview(rainFall)
        bottomBox.addArrangedSubview(windSpeed)
        bottomBox.addArrangedSubview(humidity)

//        cityNameLabel.backgroundColor = UIColor.black
        cityNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(weatherLabel.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
//        weatherLavel.backgroundColor = UIColor.systemPink
        weatherLabel.snp.makeConstraints { make in
            make.bottom.equalTo(weatherTitle.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
//        titleLabel.backgroundColor = UIColor.systemPink
        weatherTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
//            make.width.equalTo(100)
        }
        
//        bottomBox.backgroundColor = UIColor.green
        bottomBox.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherTitle.snp.bottom).offset(20)
        }
        
        rainFall.snp.makeConstraints { make in
            make.top.equalTo(tempMin.snp.bottom).offset(20)
        }
   
    }
}
