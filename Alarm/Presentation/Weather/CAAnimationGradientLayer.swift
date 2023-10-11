//
//  CAAnimationGradientLayer.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-03.
//

import UIKit

class CAAnimationGradientLayer: CAGradientLayer {
    
    var HEXca: String?
    
    let white: CGColor = UIColor.white.cgColor
 
    var gradientColorSet: [[CGColor]] = [[CGColor]]()
    
    var currentGradientColorIndex: Int = 0
    
    
    init(hex: String) {
        self.HEXca = hex
        super.init()
        animateGradient(hex: HEXca!)
    }
    
    override init() {
        super.init()
    }
    
//    override init() {
//        super.init()
//
//        
//        animateGradient(hex: HEX ?? "a2d2ff")
////        print("[CAclassBG]",self.HEX )
//
//    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Core Animation Delegate
extension CAAnimationGradientLayer: CAAnimationDelegate {
    func animateGradient(hex : String) {
        
        let cusotmHex: String = hex  

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
