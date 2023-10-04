//
//  SelectRingtoneTableViewController.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/27.
//

import UIKit
import SnapKit

class SelectRingtoneTableViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let rightBarButton = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingButtonTapped))
        leftBarButton.tintColor = .systemOrange
        rightBarButton.tintColor = .systemOrange
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func settingButtonTapped(){
        //FIXME: UserDefaults에 저장 로직 필요
        self.dismiss(animated: true)
    }

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
