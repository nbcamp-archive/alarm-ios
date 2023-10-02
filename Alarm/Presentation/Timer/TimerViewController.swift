//
//  TimerViewController.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/26.
//

import UIKit

class TimerViewController: BaseUIViewController {
    
    weak var coordinator: TimerViewCoordinator?
    
    override func setTitle() {
        title = "타이머"
    }
    
    //MARK: - Properties
    
    private let timerModel = TimerModel()
    private weak var timer: Timer?
    
    var time: [[Int]]{
        get{
            return setTime()
        }
    }
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var timePickerView: UIPickerView!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var startView: UIView!
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var ringtoneLabel: UILabel!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelView.circleView = true
        cancelButton.circleButton = true
        
        startView.circleView = true
        startButton.circleButton = true
        
        switchButtonsAppearance(state: timerModel.state)
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        timePickerView.setPickerLabelsWith(labels: ["시간","분","초"])
    }
    
    //MARK: - Appearance
    
    private func switchButtonsAppearance(state: TimerModel.State ){
        switch state {
        case .running:
            startButton.setTitle("일시 정지", for: .normal)
            startButton.backgroundColor = UIColor(named: "StopBackground")
            startButton.setTitleColor(UIColor(named: "StopText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StopBackground")
            cancelButton.alpha = 1
        case .paused:
            startButton.setTitle("재개", for: .normal)
            startButton.backgroundColor = UIColor(named: "StartBackground")
            startButton.setTitleColor(UIColor(named: "StartText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StartBackground")
        case .default:
            startButton.setTitle("시작", for: .normal)
            startButton.backgroundColor = UIColor(named: "StartBackground")
            startButton.setTitleColor(UIColor(named: "StartText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StartBackground")
            cancelButton.alpha = 0.6
        }
    }
    
    func setTime() -> [[Int]]{
        var hour: [Int] = []
        var minuteAndSecond: [Int] = []
        
        for i in 0...23{
            hour.append(i)
        }
        
        for i in 0...59{
            minuteAndSecond.append(i)
        }
        
        return [hour, minuteAndSecond, minuteAndSecond]
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    }
    
}

extension TimerViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(component){
        case 0:
            return "\(time[component][row])"
        case 1:
            return "\(time[component][row])"
        case 2:
            return "\(time[component][row])"
        default:
            return nil
        }
    }


}

extension TimerViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time[component].count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return time.count
    }
}

extension UIPickerView {
    func setPickerLabelsWith(labels: [String]) {
        let columnCount = labels.count
        let fontSize: CGFloat = UIFont.systemFontSize + 3
        
        var labelList: [UILabel] = []
        for index in 0..<columnCount {
            let label = UILabel()
            label.text = labels[index]
            label.font = .boldSystemFont(ofSize: fontSize)
            label.textColor = .black
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labelList.append(label)
        }
        
        for (index, label) in labelList.enumerated() {
            if index == 0 {
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35.0).isActive = true
            } else if index == 1 {
                label.leadingAnchor.constraint(equalTo: labelList[0].trailingAnchor, constant: -12.0).isActive = true
            } else if index == 2 {
                label.leadingAnchor.constraint(equalTo: labelList[1].trailingAnchor, constant: -5.0).isActive = true
            }
            
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0 / CGFloat(columnCount)).isActive = true
        }
    }
}
