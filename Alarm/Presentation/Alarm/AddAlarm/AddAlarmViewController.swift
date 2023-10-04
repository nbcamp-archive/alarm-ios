//
//  AddAlarmViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import SnapKit
import Then
import UIKit

class AddAlarmViewController: BaseUIViewController, RepeatViewControllerDelegate, SoundViewControllerDelegate {

    weak var coordinator: AddAlarmViewCoordinator?
    
    private var selectedSoundName: String = "전파 탐지기(기본)"
    private var selectedSoundFileName: String = "default.caf"
    
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
    
    private lazy var repeatLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var repeatCell = NavigationCell(style: .default, reuseIdentifier: "RepeatCell").then({
        $0.addSubview(repeatLabel)
        $0.configure(with: "반복")
        repeatLabel.snp.makeConstraints({ constraint in
            constraint.centerY.equalToSuperview()
            constraint.trailing.equalToSuperview().inset(35)
        })
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
    
    func didSelectSound(soundName: String) {
            soundCell.configure(with: "사운드 \(soundName)")
        switch soundName {
        case "전파 탐지기(기본)":
            selectedSoundName = soundName
            selectedSoundFileName = "default.caf"
        case "공상음":
            selectedSoundName = soundName
            selectedSoundFileName = "daydreaming.caf"
        default:
            break
        }
    }
    
    func didSelectDays(_ selectedDays: [String]) {
        let sortedSelectedDays = selectedDays.sorted { (day1, day2) in
                let dayOrder = ["월요일마다", "화요일마다", "수요일마다", "목요일마다", "금요일마다", "토요일마다", "일요일마다"]
                guard let index1 = dayOrder.firstIndex(of: day1), let index2 = dayOrder.firstIndex(of: day2) else {
                    return false
                }
                return index1 < index2
            }
            
            let abbreviatedDays = sortedSelectedDays.map { day in
                String(day.prefix(1))
            }
            repeatLabel.text = abbreviatedDays.joined(separator: ", ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setTitle() {
        navigationItem.title = "알람 추가"
    }
    
    override func setUI() {
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
    
    // "반복" 셀이 선택될 때
    private func showRepeatViewController() {
        let repeatViewController = RepeatViewController()
        repeatViewController.delegate = self
        navigationController?.pushViewController(repeatViewController, animated: true)
    }

    @objc private func cancelButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonItemTapped() {
        let time = timePicker.date
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        let hourString = String(format: "%02d", hour)
        let minuteString = String(format: "%02d", minute)
        
        let trailingText = textFieldCell.trailingTextField.text ?? "알람"
        
        let currentTone = Tone(name: selectedSoundName, filename: selectedSoundFileName)
        
        let alarm = Alarm(uuid: UUID(), hour: hourString, minute: minuteString, dayOfWeekdays: [1],
                               label: trailingText, tone: currentTone, isEnabled: true, isSnoozeEnabled: true)
        
        UserDefaultsManager.save(alarm, forKey: UserDefaultsManager.alarmGroupKey)
        AlarmScheduler.registAlarms()
        AlarmScheduler.checkScheduledAlarms()
        UserDefaultsManager.printAlarmGroup()
        print("시간: \(hour), 분: \(minute), 레이블: \(trailingText), 레이블: \(currentTone.filename)")
        dismiss(animated: true)
    }
}

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

extension AddAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showRepeatViewController()
        case 2:
            let soundViewController = SoundViewController()
            soundViewController.delegate = self
            navigationController?.pushViewController(soundViewController, animated: true)
        default:
            break
        }
    }
}
