//
//  SoundViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import SnapKit
import Then
import UIKit

protocol SoundViewControllerDelegate: AnyObject {
    func didSelectSound(soundName: String)
}

class SoundViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var backgroundView = UIVisualEffectView()
    
    weak var delegate: SoundViewControllerDelegate?
    
    private let data = ["전파 탐지기(기본 설정)", "공상음"]
    private var selectedIndices: [IndexPath] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "벨소리"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    override func setTitle() {
        title = "사운드"
    }
    
    override func setUI() {
        attachBackgroundView()
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints({ constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints { constraint in
            constraint.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(5)
            constraint.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-10)
            constraint.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { constraint in
            constraint.leading.trailing.bottom.equalToSuperview()
            constraint.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = data[indexPath.row]

    if selectedIndices.contains(indexPath) {
        cell.accessoryType = .checkmark
    } else {
        cell.accessoryType = .none
    }

    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedIndices.isEmpty {
            selectedIndices.append(indexPath)
            tableView.reloadRows(at: [indexPath], with: .none)
            
            delegate?.didSelectSound(soundName: data[indexPath.row])
            
        } else if let previousIndexPath = selectedIndices.first, previousIndexPath != indexPath {
            if let previousCell = tableView.cellForRow(at: previousIndexPath) {
                previousCell.accessoryType = .none
            }
            selectedIndices.removeAll()
            selectedIndices.append(indexPath)
            tableView.reloadRows(at: [previousIndexPath, indexPath], with: .none)
            
            delegate?.didSelectSound(soundName: data[indexPath.row])
            
        }
    }

}
// MARK: - 커스텀 메서드
extension SoundViewController {
    
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
