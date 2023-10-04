//
//  WeatherViewController.swift
//  Alarm
//
//  Created by kiakim Kim on 2023-09-26.
//

import UIKit
import SnapKit

class WeatherViewController: BaseUIViewController {
    
    let openWeatherAPI = "https://api.openweathermap.org/data/2.5/weather?q=seoul&APPID=f39b81a80e0097ae770b65082a10db12&units=metric"
    
    let todaysWeatherContainer = {
        let container = UIStackView()
        container.axis = .vertical
        return container
    }()
    
    let locationBox = {
        let box = UIStackView()
        box.axis = .vertical
        return box
    }()
    
    
    let cityNameLabel = {
        let label = UILabel()
        label.text = "cityNameLabel"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        //오늘 날짜 들어갈 수 있게 조정
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    
    let mainInfoBox = {
        let box = UIStackView()
        return box
    }()
    
    let weatherImage = {
        let image = UIImageView()
        image.image = UIImage(named: "cludy")
        
        return image
    }()
    
    
    let mainInfoInsideRigthBox = {
        let box = UIStackView()
        box.axis = .vertical
        return box
    }()
    
    let temprigthInsideStackView = {
        let box = UIStackView()
        box.axis = .horizontal
        return box
    }()
    
    let tempTodayLabel = {
        let label = UILabel()
        label.text = "온도"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 50, weight: .medium)
//         label.backgroundColor = UIColor.systemBlue
        return label
    }()
    
    
    let tempDegree  = {
        let label = UILabel()
        label.text = "°C"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
//        label.backgroundColor = UIColor.systemGreen
//        label.textAlignment = .left
        return label
    }()
    
    let weatherTodayLabel = {
        let label = UILabel()
        label.text = "weatherLabel"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
//        label.backgroundColor = UIColor.red
        return label
    }()
 
    
    let detailInfoBox = {
        let box = DetailInfoView()
          return box
    }()

    weak var coordinator: WeatherViewCoordinator?
    
    override func setTitle() {
        title = "날씨"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        callWeather()
        dateTody()
    }
    
    func dateTody(){
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "E, MMM d"
        
        let currentDate = Date()
        let formattedDate = dateFomatter.string(from: currentDate)
        dateLabel.text = formattedDate
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(hex: "#A4CAF5")
        self.view.addSubview(todaysWeatherContainer)
        todaysWeatherContainer.addArrangedSubview(locationBox)
        todaysWeatherContainer.addArrangedSubview(mainInfoBox)
        todaysWeatherContainer.addArrangedSubview(detailInfoBox)
        todaysWeatherContainer.snp.makeConstraints { make in
       }
        
      
        locationBox.addArrangedSubview(cityNameLabel)
        locationBox.addArrangedSubview(dateLabel)
        
      
        mainInfoBox.addArrangedSubview(weatherImage)
        mainInfoBox.addArrangedSubview(mainInfoInsideRigthBox)
     
        
        mainInfoInsideRigthBox.addArrangedSubview(temprigthInsideStackView)
        mainInfoInsideRigthBox.addArrangedSubview(weatherTodayLabel)
        
        temprigthInsideStackView.addArrangedSubview(tempTodayLabel)
        temprigthInsideStackView.addArrangedSubview(tempDegree)
      
//        detailInfoBox.addArrangedSubview(tempBackgroundBox)
//        detailInfoBox.addArrangedSubview(windBackgroundBox)
//        detailInfoBox.addArrangedSubview(humidityBackgroundBox)
        
//        todaysWeatherContainer.layer.borderWidth = 1
        todaysWeatherContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.left.equalTo(view.snp.left).offset(30)
            make.right.equalTo(view.snp.right).offset(-30)
        }
        
        //MARK: LocationArea
        locationBox.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(5) 
           }
        
        //MARK: MainInfoArea
        mainInfoBox.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(3)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalToSuperview()
        }
        
        mainInfoInsideRigthBox.distribution = .fillProportionally
        mainInfoInsideRigthBox.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            
            make.height.equalToSuperview().dividedBy(1.5)
            make.trailing.equalToSuperview().offset(-20)
        }

        tempDegree.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(20)
        }
        
      
        }
    }
