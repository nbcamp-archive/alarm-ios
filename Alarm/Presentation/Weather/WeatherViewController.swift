//
//  WeatherViewController.swift
//  Alarm
//
//  Created by kiakim Kim on 2023-09-26.
//

import UIKit
import SnapKit






class WeatherViewController: BaseUIViewController {
    
   
    var weatherConditon: Int = 800
  
    
    let openWeatherAPI = "https://api.openweathermap.org/data/2.5/weather?q=seoul&APPID=f39b81a80e0097ae770b65082a10db12&units=metric"
    
    let todaysWeatherContainer = {
        let container = UIStackView()
        container.axis = .vertical
        return container
    }()
    
    let testBox = {
        let box = UIView()
        box.layer.borderWidth = 1
        return box
        
    }()
    
    let testCode = {
        let code = UILabel()
        code.text = "sdfs"
        return code
    }()
    
    
    let locationBox = {
        let box = UIStackView()
        box.axis = .vertical
        return box
    }()
    
    
    let cityNameLabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    
    let mainInfoBox = {
        let box = UIStackView()
        box.alignment = .center
        return box
    }()
    
    let weatherImage = {
        let image = UIImageView()
        image.image = UIImage(named: "cludy")
        image.contentMode = .scaleAspectFit
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
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        return label
    }()
    
    
    let tempDegree  = {
        let label = UILabel()
        label.text = "°C"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let weatherTodayLabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
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

        
//        print("딱!",weatherConditon)
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
        
        self.view.addSubview(testBox)
        testBox.addSubview(testCode)
    
        
        todaysWeatherContainer.addArrangedSubview(locationBox)
        todaysWeatherContainer.addArrangedSubview(mainInfoBox)
        todaysWeatherContainer.addArrangedSubview(detailInfoBox)
      
        locationBox.addArrangedSubview(cityNameLabel)
        locationBox.addArrangedSubview(dateLabel)
        
      
        mainInfoBox.addArrangedSubview(weatherImage)
        mainInfoBox.addArrangedSubview(mainInfoInsideRigthBox)
     
        
        mainInfoInsideRigthBox.addArrangedSubview(temprigthInsideStackView)
        mainInfoInsideRigthBox.addArrangedSubview(weatherTodayLabel)
        
        temprigthInsideStackView.addArrangedSubview(tempTodayLabel)
        temprigthInsideStackView.addArrangedSubview(tempDegree)
      
                testBox.snp.makeConstraints { make in
            make.bottom.equalTo(locationBox.snp.top)
            make.right.equalToSuperview().offset(-50)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        
        testCode.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
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
            make.width.equalTo(180)
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
