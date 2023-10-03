//
//  CAAnimationGradientLayer.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-03.
//

import UIKit

class CAAnimationGradientLayer: CAGradientLayer {
    
    //FIXME: 색상은 자유롭게 수정하셔도 될 것 같습니다.
    private let coral: CGColor = UIColor(hex: "#F94144").cgColor
    private let violet: CGColor = UIColor(hex: "#BC00DD").cgColor
    private let mustard: CGColor = UIColor(hex: "#FFD60A").cgColor
    private let green: CGColor = UIColor(hex: "#AACC00").cgColor
    
    private var gradientColorSet: [[CGColor]] = [[CGColor]]()
    
    private var currentGradientColorIndex: Int = 0
    
    override init() {
        super.init()
        
        //FIXME: 움직이는 원리는 2차원 배열 형태로 색상을 지속시간 동안 반복적으로 변경하는 형태입니다.
        gradientColorSet.append([coral, mustard])
        gradientColorSet.append([mustard, green])
        gradientColorSet.append([green, violet])
        gradientColorSet.append([violet, violet])
        
        self.colors = gradientColorSet[currentGradientColorIndex]
        animateGradient()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Core Animation Delegate
extension CAAnimationGradientLayer: CAAnimationDelegate {
    func animateGradient() {
        if currentGradientColorIndex < gradientColorSet.count - 1 {
            currentGradientColorIndex += 1
        } else {
            currentGradientColorIndex = 0
        }
        
        //FIXME: 코어 애니메이션 동작과 관련된 속성은 다음과 같습니다.
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 8.0
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
                self.animateGradient()
            }
        }
    }
}
