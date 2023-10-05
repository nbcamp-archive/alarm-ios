//
//  CAAnimationGradientLayer.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-03.
//

import UIKit

class CAAnimationGradientLayer: CAGradientLayer {
    
//    var HEX = WeatherViewController().HEX
    
    let pink: CGColor = UIColor.systemPink.cgColor
    let blue: CGColor = UIColor.systemBlue.cgColor
    let green: CGColor = UIColor.systemGreen.cgColor
    let white: CGColor = UIColor.white.cgColor
    

    

    var gradientColorSet: [[CGColor]] = [[CGColor]]()
    
    var currentGradientColorIndex: Int = 0
    
    
    
    override init() {
        super.init()
        

        
        //FIXME: 움직이는 원리는 2차원 배열 형태로 색상을 지속시간 동안 반복적으로 변경하는 형태입니다.
        

        //No.1
//        gradientColorSet.append([pink, blue])
//        gradientColorSet.append([blue, green])
//        gradientColorSet.append([green, white])
//        gradientColorSet.append([white, pink])
        
     //hex값을 changeIconAndBG에서 적용하고, 여기에는 변수명으로 전달받게 하면 어떨까
        
        animateGradient(hex: WeatherViewController().HEX) //
//        animateGradient(hex: "d62828") //red [Now]
        print("2.HEX-skyblue", WeatherViewController().HEX)
        

    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Core Animation Delegate
extension CAAnimationGradientLayer: CAAnimationDelegate {
    func animateGradient(hex : String) {
        
        //변경하고 싶은 부분 here
        let cusotmHex: String = hex  
    //    var cusotmHex: String = "3a86ff"
    //    var cusotmHex: String = "03045e"
        
        //No.2
        gradientColorSet.append([white,UIColor(hex: cusotmHex).cgColor])
        gradientColorSet.append([UIColor(hex: cusotmHex).cgColor,white])
        
        self.colors = gradientColorSet[currentGradientColorIndex]
        
        if currentGradientColorIndex < gradientColorSet.count - 1 {
            currentGradientColorIndex += 1
        } else {
            currentGradientColorIndex = 0
        }
        
        //FIXME: 코어 애니메이션 동작과 관련된 속성은 다음과 같습니다.
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 2.5
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.repeatCount = Float.infinity
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        
        gradientChangeAnimation.toValue = gradientColorSet[currentGradientColorIndex]
        
        add(gradientChangeAnimation, forKey: "colorChange")
//        setNeedsDisplay()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            colors = gradientColorSet[currentGradientColorIndex]
            CATransaction.commit()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animateGradient(hex: "fb8500") //오렌지
            }
        }
    }
}


//extension UIView{
//    func setGradient(color1:UIColor,color2:UIColor){
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [color1.cgColor,color2.cgColor]
//        gradient.locations = [0.0 , 1]
//        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.6, y: 0.6)
//        gradient.frame = bounds
//        layer.addSublayer(gradient)
//    }
//}
