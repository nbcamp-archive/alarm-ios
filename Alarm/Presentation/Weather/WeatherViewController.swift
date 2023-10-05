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
    
    //기본값에서 바뀌지 않는 문제
    var HEX: String = "a2d2ff" //skyblue
    
    
    let openWeatherAPI = "https://api.openweathermap.org/data/2.5/weather?q=seoul&APPID=f39b81a80e0097ae770b65082a10db12&units=metric"
    
    
    lazy var backgroundView = {
        let view = UIView()
        let gradientBG = CAAnimationGradientLayer()
        gradientBG.frame = self.view.bounds
        gradientBG.startPoint = CGPoint(x: 0, y: 0)
        gradientBG.endPoint = CGPoint(x: 1, y: 1)
        gradientBG.drawsAsynchronously = true
        view.layer.addSublayer(gradientBG)
        return view
    }()
    
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
        box.alignment = .firstBaseline
        box.distribution = .fillEqually
        box.spacing = 0
        
        return box
    }()
    
    let tempTodayLabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        return label
    }()
    
    
    let tempDegree  = {
        let label = UILabel()
        label.text = "°C"
        label.textAlignment = .left
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

//MARK: Memo : 파라미터 이해
//        callweather2(completeHandeler: 3)
//
//        callWeather(completionHandler: { result in  })
//
//        callWeather { <#Bool#> in
//            <#code#>
//        }
        
        loadingScreen()
  
        callWeather { result in
            if result {
               print("API 호출 성공")
                //숨겨지지않음
                self.hiddenLoadingScreen()
            }
            self.changeIconAndBG() //switch
            
            
            print("아오",self.HEX)
            
            self.setupUI()
            self.dateTody()
          
            //loadingScreen off 필요
        }

    }
    
    func loadingScreen()->UILabel{
        
        let titleLabel = {
            let label = UILabel()
            label.text = "Loading ..."
            label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            label.textAlignment = .center
            return label
        }()
        
        self.view.addSubview(titleLabel)
        titleLabel.isHidden = false
//        titleLabel.backgroundColor = UIColor.red
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(100)

        }
        return titleLabel
    }
    
    func hiddenLoadingScreen(){
        let loadingScreen = loadingScreen()
        loadingScreen.isHidden = true
    }
    
    func dateTody(){
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "E, MMM d"
        
        let currentDate = Date()
        let formattedDate = dateFomatter.string(from: currentDate)
        dateLabel.text = formattedDate
    }
    
    func setupUI(){
        
        //gradient Background color
        let gradientLayer = CAAnimationGradientLayer() //에메랄드
//        gradientLayer.frame = view.bounds
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        gradientLayer.drawsAsynchronously = true

       

        
        self.view.addSubview(backgroundView)
//        backgroundView.layer.addSublayer(gradientLayer)
        backgroundView.addSubview(todaysWeatherContainer)
     
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
        }
        
        tempDegree.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(10)
        }
        
      
        }
    }
