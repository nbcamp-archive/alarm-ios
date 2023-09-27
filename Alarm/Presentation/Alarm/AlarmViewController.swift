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
        Alarm(time: "08:00 오전", label: "아침 알람"),
        Alarm(time: "12:10 오후", label: "점심 알람")
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
        
    }
    
    @objc func addAlarmButtonTapped() {
        // 현재 시간 얻기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let currentTime = dateFormatter.string(from: Date())
        
        // 새로운 알람 추가
        let newAlarm = Alarm(time: currentTime, label: "새 알람")
        alarms.append(newAlarm)
        tableView.reloadData()
    }
}

extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AlarmCell")
        let alarm = alarms[indexPath.row]
        
        cell.textLabel?.text = alarm.time
        cell.detailTextLabel?.text = alarm.label
        cell.selectionStyle = .none
        
        return cell
    }
}
