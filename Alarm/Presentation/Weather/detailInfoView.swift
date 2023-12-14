//
//  detailInfoView.swift
//  Alarm
//
//  Created by kiakim on 2023/09/27.
//

import UIKit
import SnapKit

class DetailInfoView : UIView {
    
    
    let bodyContainer = {
        let box = UIStackView()
        box.axis = .vertical
        return box
    }()
    
    let tempBackgroundBox = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.backgroundColor = UIColor.white
        view.layer.backgroundColor = (UIColor.white.cgColor).copy(alpha: 0.3)
        view.layer.borderColor = (UIColor.white.cgColor).copy(alpha: 0.3)
        view.layer.borderWidth = 2
        return view
    }()
    
    var tempMax = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.layer.addBorder([.right], color: UIColor.black, width: 1)
        return label
    }()
    
    var centerBar = {
        let bar = UIView()
        bar.backgroundColor = UIColor.systemGray
        return bar
    }()
    
    var tempMin = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let windBackgroundBox = {
        let view = UIStackView()
        view.axis = .horizontal
        view.backgroundColor = UIColor.white
        view.layer.backgroundColor = (UIColor.white.cgColor).copy(alpha: 0.3)
        view.layer.borderColor = (UIColor.white.cgColor).copy(alpha: 0.3)
        view.layer.borderWidth = 2
        return view
    }()
    
    let windIcon = {
        let icon = UIImageView()
        icon.image = UIImage(named: "wind")
        icon.contentMode  = .scaleAspectFill
        return icon
    }()
    
    let windTitle = {
        let title = UILabel()
        title.text = "Wind"
        return title
    }()
     
    let windData = {
        let title = UILabel()
        title.textAlignment = .center
        return title
    }()
    
    
    let humidityBackgroundBox = {
        let view = UIStackView()
        view.axis = .horizontal
        view.backgroundColor = UIColor.white
        view.layer.backgroundColor = (UIColor.white.cgColor).copy(alpha: 0.3)
        view.layer.borderColor = (UIColor.white.cgColor).copy(alpha: 0.3)
        view.layer.borderWidth = 2
        return view
    }()
    
    let humidityIcon = {
        let icon = UIImageView()
        icon.image = UIImage(named: "humidity") 
        icon.contentMode  = .scaleAspectFill
        
        return icon
    }()
    
    let humidityTitle = {
        let title = UILabel()
        title.text = "Humidity"
        return title
    }()
     
    let humidityData = {
        let title = UILabel()
        title.textAlignment = .center
        return title
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    func setupUI(){
        self.addSubview(bodyContainer)
        bodyContainer.addArrangedSubview(tempBackgroundBox)
        bodyContainer.addArrangedSubview(windBackgroundBox)
        bodyContainer.addArrangedSubview(humidityBackgroundBox)
        
        tempBackgroundBox.addArrangedSubview(tempMax)
        tempBackgroundBox.addArrangedSubview(centerBar)
        tempBackgroundBox.addArrangedSubview(tempMin)
        
        windBackgroundBox.addArrangedSubview(windIcon)
        windBackgroundBox.addArrangedSubview(windTitle)
        windBackgroundBox.addArrangedSubview(windData)
        
        humidityBackgroundBox.addArrangedSubview(humidityIcon)
        humidityBackgroundBox.addArrangedSubview(humidityTitle)
        humidityBackgroundBox.addArrangedSubview(humidityData)
     
        
        bodyContainer.distribution = .equalSpacing
        bodyContainer.spacing = 5
        bodyContainer.snp.makeConstraints { make in
            // [Bug2]: Constraint edges로 해결
            make.edges.equalToSuperview()
        }
        
        tempBackgroundBox.layer.cornerRadius = 10
        tempBackgroundBox.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(3.5)
            make.top.equalToSuperview()
       }
        centerBar.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalToSuperview().dividedBy(2)
        }
        windBackgroundBox.layer.cornerRadius = 10
        windBackgroundBox.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(3.5)
       }
        windIcon.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        windData.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        humidityBackgroundBox.layer.cornerRadius = 10
        humidityBackgroundBox.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(3.5)
        }
        humidityIcon.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        humidityData.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
    }
}
