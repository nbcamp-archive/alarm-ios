//
//  RepeatViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import SnapKit
import Then
import UIKit

protocol RepeatViewControllerDelegate: AnyObject {
    func didSelectDays(_ selectedDays: [String])
}

class RepeatViewController: BaseUIViewController {
    
    weak var delegate: RepeatViewControllerDelegate?
    
    private var selectedDays: [String] = []
    private let cellIdentifier = "7daysCell"
    private let daysOfWeek = ["월요일마다", "화요일마다", "수요일마다", "목요일마다", "금요일마다", "토요일마다", "일요일마다"]
    
    private lazy var backgroundView = UIVisualEffectView()
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then({
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    })
    
    override func setTitle() {
        title = "반복"
    }
    
    override func setUI() {
        navigationController?.navigationBar.tintColor = UIColor.black
        attachBackgroundView()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsMultipleSelection = true // 중복 선택 가능
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
        tableView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview().offset(32)
            constraint.leading.trailing.bottom.equalToSuperview()
        }
    }
    
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
        
        backgroundView.contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
    }
}

extension RepeatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let day = daysOfWeek[indexPath.row]
        
        cell.textLabel?.text = day
        
        cell.accessoryType = selectedDays.contains(day) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDay = daysOfWeek[indexPath.row]
        
        if let index = selectedDays.firstIndex(of: selectedDay) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(selectedDay)
        }
        
        tableView.reloadData()
        
        delegate?.didSelectDays(selectedDays)
    }
}
