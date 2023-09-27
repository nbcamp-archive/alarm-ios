//
//  AddAlarmViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import SnapKit
import Then
import UIKit

class AddAlarmViewController: BaseUIViewController {
    
    weak var coordinator: AddAlarmViewCoordinator?
    
    private lazy var backgroundView = UIVisualEffectView()
    
    private lazy var cancelButtonItem = UIBarButtonItem().then({
        $0.title = "취소"
        $0.tintColor = UIColor.black
        $0.action = #selector(cancelButtonItemTapped)
        $0.isEnabled = true
    })
    
    private lazy var saveButtonItem = UIBarButtonItem().then({
        $0.title = "저장"
        $0.tintColor = UIColor.black
        $0.action = #selector(saveButtonItemTapped)
        $0.isEnabled = true
    })
    
    private lazy var timePicker = UIDatePicker().then({
        $0.preferredDatePickerStyle = .wheels
        $0.timeZone = .autoupdatingCurrent
        $0.datePickerMode = .time
    })
    
    private lazy var timeTableView = UITableView().then({
        $0.rowHeight = 60
    })
    
    override func setTitle() {
        super.setTitle()
        
        navigationItem.title = "알람 추가"
    }
    
    override func setUI() {
        super.setUI()
        
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
        
        attachBackgroundView()
        view.addSubview(timePicker)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
        timePicker.snp.makeConstraints({ constraint in
            constraint.centerX.equalToSuperview()
        })
    }
    
    override func setDelegate() {
        
    }
    
    override func addTarget() {
        cancelButtonItem.target = self
        saveButtonItem.target = self
    }
    
}
// MARK: - 커스텀 메서드
extension AddAlarmViewController {
    
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

// MARK: - 액션 메서드
extension AddAlarmViewController {
    
    @objc
    private func cancelButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func saveButtonItemTapped() {
        dismiss(animated: true)
    }
}
