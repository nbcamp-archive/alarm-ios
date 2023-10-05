//
//  SelectRingtoneTableViewController.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/27.
//

import UIKit
import SnapKit

protocol ModalViewControllerDelegate: AnyObject {
    func didDismissModalViewController(alarmSound: String)
}

class SelectRingtoneTableViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ModalViewControllerDelegate?
    
    private lazy var backgroundView = UIVisualEffectView()
    
    private let data = ["전파 탐지기(기본 설정)", "공상음"]
    private let dataFile = ["default.caf", "daydreaming.caf"]
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private var selectedIndexPath: IndexPath?
    private var selectedSound: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "타이머 종료 시"

        let leftBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let rightBarButton = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingButtonTapped))
        leftBarButton.tintColor = .systemOrange
        rightBarButton.tintColor = .systemOrange
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        if let savedSound = UserDefaults.standard.string(forKey: "Timer_AlarmSound"),
           let row = data.firstIndex(of: savedSound) {
            selectedIndexPath = IndexPath(row: row, section: 0)
            selectedSound = savedSound
        }
    }
    
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func settingButtonTapped(){
        if let selectedSound = selectedSound, let row = data.firstIndex(of: selectedSound) {
            UserDefaults.standard.set(selectedSound, forKey: "Timer_AlarmSound")
            UserDefaults.standard.set(dataFile[row], forKey: "Timer_AlarmSoundFile")
            
            delegate?.didDismissModalViewController(alarmSound: selectedSound)
        }
        
        self.dismiss(animated: true)
    }
    
    override func setUI() {
        attachBackgroundView()
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
        
        tableView.snp.makeConstraints { constraint in
            constraint.leading.trailing.bottom.equalToSuperview()
            constraint.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-10)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]

        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if selectedIndexPath != indexPath {
            selectedSound = data[indexPath.row]
            selectedIndexPath = indexPath
        }

        tableView.reloadData()
    }

}
// MARK: - 커스텀 메서드
extension SelectRingtoneTableViewController {
    
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
