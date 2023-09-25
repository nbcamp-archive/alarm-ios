//
//  BaseUIViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setTitle()
        
        setUI()
        
        setLayout()
        
        setDelegate()
        
        addTarget()
    }
    
    /// 최상위 뷰 타이틀을 설정하기 위한 메서드
    func setTitle() {}
    
    /// UI 설정을 위한 메서드
    func setUI() {}
    
    /// 레이아웃 설정을 위한 메서드
    func setLayout() {}
    
    /// 델리게이트 설정을 위한 메서드
    func setDelegate() {}
    
    /// 타겟-액션 메서드 설정을 위한 메서드
    func addTarget() {}
    
}
