//
//  AlarmViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class AlarmViewController: BaseUIViewController {
    
    weak var coordinator: AlarmViewCoordinator?
    
    override func setTitle() {
        title = "알람"
    }
    
    // 알람 모델
    struct Alarm {
        var time: String
        var label: String
    }
    
    // 알람 목록
    var alarms: [Alarm] = [
        Alarm(time: "11:00 AM", label: "아침 알람"),
        Alarm(time: "12:10 PM", label: "점심 알람")
    ]
    
    // 테이블 뷰
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlarmCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 알람 추가 버튼
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlarmButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        // 테이블 뷰 헤더
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = 50
    }
    
//    @objc func addAlarmButtonTapped() {
//        // 현재 시간 얻기
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//        dateFormatter.amSymbol = "AM"
//        dateFormatter.pmSymbol = "PM"
//        let currentTime = dateFormatter.string(from: Date())
//
//        // 알람 추가
//        let newAlarm = Alarm(time: currentTime, label: "새 알람")
//        alarms.append(newAlarm)
//        tableView.reloadData()
//    }
    
    @objc func addAlarmButtonTapped() {
        coordinator?.toAddAlarmView()
    }
}

extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width - 32, height: 30))
            label.text = "Other"
            label.font = UIFont.systemFont(ofSize: 18.4, weight: .semibold)
            headerView.addSubview(label)
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 30 : 0 // 첫 번째 섹션에만 헤더가 표시되도록 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AlarmCell")
        let alarm = alarms[indexPath.row]
        
        // 시간 부분 폰트 설정
            let timeText = NSMutableAttributedString(string: alarm.time)
            timeText.addAttribute(.font, value: UIFont(name: "SFProDisplay-Light", size: 40) ?? UIFont.systemFont(ofSize: 40), range: NSRange(location: 0, length: 5))
            
        // "오전" 또는 "오후" 부분 폰트 설정
            let amPmRange = (alarm.time as NSString).range(of: "AM,PM")
            if amPmRange.location != NSNotFound {
                timeText.addAttribute(.font, value: UIFont(name: "SFProDisplay-Light", size: 20) ?? UIFont.systemFont(ofSize: 20), range: amPmRange)
            }
            
            cell.textLabel?.attributedText = timeText
        
        cell.detailTextLabel?.text = alarm.label
        cell.detailTextLabel?.frame = CGRect(x: 0, y: 0, width: 37, height: 16)
//            cell.detailTextLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            cell.detailTextLabel?.font = UIFont(name: "SFProText-Regular", size: 13.8)
        
        cell.selectionStyle = .none
        
        // 토글 스위치 추가
        let switchView = UISwitch()
        switchView.isOn = false // 꺼진 상태로 설정
        switchView.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)
        cell.accessoryView = switchView // 셀에 토글 스위치 추가
        
        return cell
    }
    
    @objc func toggleSwitch(_ sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let alarm = alarms[indexPath.row]
            alarmSwitchValueChanged(isOn: sender.isOn, forAlarm: alarm)
        }
    }
    
    func alarmSwitchValueChanged(isOn: Bool, forAlarm alarm: Alarm) {

        if isOn {
        } else {
        }
    }
}
