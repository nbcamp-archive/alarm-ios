//
//  CircularSliderView.swift
//  Alarm
//
//  Created by 이재희 on 2023/10/04.
//

import UIKit

class CircularSliderView: UIView {

    private var countdownTime: Int = 0
    
    private var animatedCountdownStrokeLayer: CAShapeLayer!
    
    func setCoundownTime(seconds: Int) {
        countdownTime = seconds
    }
    
    func createCountdownStrokeLayer(color: UIColor) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: center, radius: 170, startAngle: 3 * .pi/2, endAngle: -.pi/2, clockwise: false)
        let circleLayer = CAShapeLayer()
        
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = color.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 8
        
        return circleLayer
    }
    
    private func createCountdownAnimation() -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "strokeStart")
        anim.toValue = 1
        anim.duration = Double(countdownTime)
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        return anim
    }
    
    func startCountdownAnimation() {
        let anim = createCountdownAnimation()
        animatedCountdownStrokeLayer.speed = 1.0
        animatedCountdownStrokeLayer.lineCap = .round
        animatedCountdownStrokeLayer.add(anim, forKey: "")
    }
    
    func pauseCountdownAnimation() {
        let pausedTime : CFTimeInterval = animatedCountdownStrokeLayer.convertTime(CACurrentMediaTime(), from: nil)
        animatedCountdownStrokeLayer.speed = 0.0
        animatedCountdownStrokeLayer.timeOffset = pausedTime
    }
    
    func resumeCountdownAnimation() {
        let pausedTime = animatedCountdownStrokeLayer.timeOffset
        animatedCountdownStrokeLayer.speed = 1.0
        animatedCountdownStrokeLayer.timeOffset = 0.0
        animatedCountdownStrokeLayer.beginTime = 0.0
        let timeSincePause = animatedCountdownStrokeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        animatedCountdownStrokeLayer.beginTime = timeSincePause
    }
    
    func cancelCountdownAnimation() {
        animatedCountdownStrokeLayer.removeAllAnimations()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(createCountdownStrokeLayer(color: UIColor.darkGray.withAlphaComponent(0.5)))
        animatedCountdownStrokeLayer = createCountdownStrokeLayer(color: .systemOrange)
        layer.addSublayer(animatedCountdownStrokeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
