//
//  RepeatViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import SnapKit
import Then
import UIKit

class RepeatViewController: BaseUIViewController {
    
    private lazy var backgroundView = UIVisualEffectView()
    override func setTitle() {
        title = "반복"
    }
    
    override func setUI() {
        attachBackgroundView()
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
    }
    
}
// MARK: - 커스텀 메서드
extension RepeatViewController {
    
    private func attachBackgroundView() {
        let style: UIBlurEffect.Style
        
        if #available(iOS 13.0, *) {
            style = .systemMaterial
        } else {
            style = .light
        }
        
        let effect = UIBlurEffect(style: style)
        backgroundView.effect = effect
        
        view.backgroundColor = .clear
        view.insertSubview(backgroundView, at: 0)
    }
    
}
