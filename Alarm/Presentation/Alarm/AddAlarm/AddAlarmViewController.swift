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
    
    private lazy var repeatCell = NavigationCell(style: .default, reuseIdentifier: "RepeatCell").then({
        $0.configure(with: "반복")
    })
    
    private lazy var textFieldCell = TextFieldCell(style: .default, reuseIdentifier: "TextFieldCell").then({
        $0.configure(with: "레이블")
    })
    
    private lazy var soundCell = NavigationCell(style: .default, reuseIdentifier: "SoundCell").then({
        $0.configure(with: "사운드")
    })
    
    private lazy var snoozeCell = SnoozeCell(style: .default, reuseIdentifier: "SnoozeCell").then({
        $0.configure(with: "다시 알림")
    })
    
    private lazy var timeTableView = UITableView(frame: .zero, style: .insetGrouped).then({
        $0.isScrollEnabled = false
        $0.backgroundView = .none
        $0.backgroundColor = .clear
        $0.rowHeight = 44
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
        view.addSubview(timeTableView)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
        timePicker.snp.makeConstraints({ constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.centerX.equalToSuperview()
        })
        timeTableView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.equalToSuperview()
            constraint.top.equalTo(timePicker.snp.bottom)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    override func setDelegate() {
        timeTableView.dataSource = self
        timeTableView.delegate = self
    }
    
    override func addTarget() {
        cancelButtonItem.target = self
        saveButtonItem.target = self
    }
    
}
// MARK: - UITableView DataSource
extension AddAlarmViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = repeatCell
            return cell
        case 1:
            let cell = textFieldCell
            return cell
        case 2:
            let cell = soundCell
            return cell
        case 3:
            let cell = snoozeCell
            return cell
        default:
            fatalError("해당하는 내용이 없습니다.")
        }
    }
    
}
// MARK: - UITableView Delegate
extension AddAlarmViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                let viewController = RepeatViewController()
                navigationController?.pushViewController(viewController, animated: true)
                print("반복 화면 코디네이터 실행 됨")
            case 2:
                let viewController = SoundViewController()
                navigationController?.pushViewController(viewController, animated: true)
                print("반복 화면 코디네이터 실행 됨")
            default:
                break
        }
    }
    
}
// MARK: - 커스텀 메서드
extension AddAlarmViewController {
    
    private func attachBackgroundView() {
        let style: UIBlurEffect.Style
        
        if #available(iOS 13.0, *) {
            style = .systemThinMaterial
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
