//
//  AlarmViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class AlarmViewController: BaseUIViewController {
    
    weak var coordinator: AlarmViewCoordinator?
    
    private var isEditingMode = false
    
    private var alarmGroup: [Alarm] = []
    
    private lazy var addButtonItem = UIBarButtonItem().then({
        $0.image = UIImage(systemName: "plus")
        $0.tintColor = UIColor.black
        $0.action = #selector(addAlarmButtonTapped)
        $0.isEnabled = true
    })
    
    private lazy var editingButtonItem = UIBarButtonItem().then({
        $0.title = "편집"
        $0.tintColor = UIColor.black
        $0.action = #selector(editButtonTapped)
        $0.isEnabled = true
    })
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then({
        $0.separatorStyle = .singleLine
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        tableView.delegate = self
        tableView.dataSource = self

        alarmGroup = UserDefaultsManager.load(forKey: UserDefaultsManager.alarmGroupKey)

        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlarmCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        alarmGroup = UserDefaultsManager.load(forKey: UserDefaultsManager.alarmGroupKey)
        
        tableView.reloadData()
    }
    
    override func setTitle() {
        title = "알람"
    }
    
    override func setUI() {
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.leftBarButtonItem = editingButtonItem
        
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        addButtonItem.target = self
        editingButtonItem.target = self
    }
    
}
//MARK: - UITableView 데이터소스
extension AlarmViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // 첫 번째 셀 '기타'는 편집 모드에서 제외
        return indexPath.row != 0
    }
    
}
//MARK: - UITableView 델리게이트
extension AlarmViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmGroup.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 93
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
            cell.textLabel?.text = "기타"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18.4, weight: .bold)
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AlarmCell")
            let alarm = alarmGroup[indexPath.row - 1]
            
            // 시간 부분 폰트 설정
            let timeText = NSMutableAttributedString(string: "\(alarm.hour):\(alarm.minute)")
            timeText.addAttribute(.font, value: UIFont(name: "SFProDisplay-Light", size: 40) ?? UIFont.systemFont(ofSize: 40), range: NSMakeRange(0, timeText.length))
            
            cell.textLabel?.attributedText = timeText
            
            cell.detailTextLabel?.text = alarm.label
            cell.detailTextLabel?.frame = CGRect(x: 0, y: 0, width: 37, height: 16)
            cell.detailTextLabel?.font = UIFont(name: "SFProText-Regular", size: 13.8)
            
            cell.selectionStyle = .none
            
            // 토글 스위치 추가
            let switchView = UISwitch()
            switchView.isOn = alarm.isEnabled
            switchView.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)
            
            cell.accessoryView = switchView
            
            return cell
        }
    }
    
    func alarmSwitchValueChanged(isOn: Bool, forAlarm alarm: Alarm) {
        if isOn {
            // 스위치가 켜진 경우의 동작
        } else {
            // 스위치가 꺼진 경우의 동작
        }
    }
    
}
//MARK: - 커스텀 액션
extension AlarmViewController {
    
    @objc
    private func editButtonTapped() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem?.title = "편집"
        } else {
            tableView.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem?.title = "완료"
        }
        // 편집 모드 상태 업데이트
        isEditingMode = tableView.isEditing
    }
    
    @objc
    private func addAlarmButtonTapped() {
        // 편집 모드 활성중 실행시 편집 모드 종료
        if isEditingMode {
            editButtonTapped()
        }
        coordinator?.toAddAlarmView()
    }
    
    @objc
    private func toggleSwitch(_ control: UISwitch) {
        if let cell = control.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let alarm = alarmGroup[indexPath.row - 1]
            alarm.isEnabled = control.isOn
            
            UserDefaultsManager.updateAlarm(alarm, forKey: "AlarmGroup")
            AlarmScheduler.registAlarms()
        }
    }
    
}
