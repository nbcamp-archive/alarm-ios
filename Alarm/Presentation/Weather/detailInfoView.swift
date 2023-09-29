//
//  detailInfoView.swift
//  Alarm
//
//  Created by kiakim on 2023/09/27.
//

import Foundation
import UIKit
import SnapKit

class DetailInfoView : UIView {
    
    
    let bodyContainer : UIStackView = {
        let box = UIStackView()
        box.axis = .vertical
        return box
    }()
    
    let tempBackgroundBox: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        
        return view
    }()
    
    var tempMax: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.systemYellow
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
   
        label.layer.addBorder([.right], color: UIColor.black, width: 1)
        return label
    }()
    
    var tempMin: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.systemTeal
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let windBackgroundBox: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
//        view.distribution = .fillProportionally
        return view
    }()
    
    let windIcon: UIImageView = {
        let icon = UIImageView()
//        icon.image = UIImage(systemName: "wind")
//        icon.backgroundColor = UIColor.systemYellow
        return icon
    }()
    
    let windTitle: UILabel = {
        let title = UILabel()
        title.text = "Wind"
//        title.backgroundColor = UIColor.systemBlue
        return title
    }()
     
    let windData: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
//        title.backgroundColor = UIColor.systemRed
        return title
    }()
    
    
    let humidityBackgroundBox: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
//        view.distribution = .
        return view
    }()
    
    let humidityIcon: UIImageView = {
        let icon = UIImageView()
//        icon.image = UIImage(systemName: "drop.fill")
//        icon.backgroundColor = UIColor.systemYellow
        return icon
    }()
    
    let humidityTitle: UILabel = {
        let title = UILabel()
        title.text = "Humidity"
//        title.backgroundColor = UIColor.systemBlue
        return title
    }()
     
    let humidityData: UILabel = {
        let title = UILabel()
        title.textAlignment = .center

//        title.backgroundColor = UIColor.systemRed

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
        tempBackgroundBox.addArrangedSubview(tempMin)
        
        windBackgroundBox.addArrangedSubview(windIcon)
        windBackgroundBox.addArrangedSubview(windTitle)
        windBackgroundBox.addArrangedSubview(windData)
        
        humidityBackgroundBox.addArrangedSubview(humidityIcon)
        humidityBackgroundBox.addArrangedSubview(humidityTitle)
        humidityBackgroundBox.addArrangedSubview(humidityData)
     
        
        //MARK: DetailInfoArea
        //        bodyContainer.backgroundColor = UIColor.red
//        bodyContainer.layer.borderWidth = 1
        bodyContainer.distribution = .equalSpacing
        bodyContainer.spacing = 5
        bodyContainer.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
            //            make.height.equalToSuperview().dividedBy(2)
        }
        
        
        tempBackgroundBox.backgroundColor = UIColor.systemGray5
        tempBackgroundBox.layer.cornerRadius = 10
        tempBackgroundBox.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(3.5)
            make.top.equalToSuperview()
       }
        
        windBackgroundBox.backgroundColor = UIColor.systemGray5
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
        
        humidityBackgroundBox.backgroundColor = UIColor.systemGray5
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
