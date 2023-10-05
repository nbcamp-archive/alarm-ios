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
    private(set) var circularSlider: CircularSliderView!
    
    var time: [[Int]]{
        get{
            return setTime()
        }
    }
    
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var timePickerView: UIPickerView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var bellImageView: UIImageView!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endTimeStackView: UIStackView!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var startView: UIView!
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var ringtoneLabel: UILabel!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCircle()

        cancelView.circleView = true
        cancelButton.circleButton = true
        
        startView.circleView = true
        startButton.circleButton = true
        
        setupUI(state: timerModel.state)
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        timePickerView.setPickerLabelsWith(labels: ["시간","분","초"])
        
        //FIXME: Notification 말고 델리게이트 방식 고려해보기
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerLabel), name: .timerValueChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStateToDefault), name: .timerStopped, object: nil)
    }
    
    //MARK: - Appearance
    
    private func setupUI(state: TimerModel.State ){
        switch state {
        case .running:
            startButton.setTitle("일시 정지", for: .normal)
            startButton.backgroundColor = UIColor(named: "StopBackground")
            startButton.setTitleColor(UIColor(named: "StopText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StopBackground")
            cancelButton.alpha = 1
            
            timePickerView.isHidden = true
            timerLabel.isHidden = false
            endTimeStackView.isHidden = false
            endTimeStackView.tintColor = .darkGray
            circularSlider.isHidden = false
            
        case .paused:
            startButton.setTitle("재개", for: .normal)
            startButton.backgroundColor = UIColor(named: "StartBackground")
            startButton.setTitleColor(UIColor(named: "StartText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StartBackground")
            
            endTimeStackView.tintColor = .lightGray
            
        case .default:
            startButton.setTitle("시작", for: .normal)
            startButton.backgroundColor = UIColor(named: "StartBackground")
            startButton.setTitleColor(UIColor(named: "StartText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StartBackground")
            cancelButton.alpha = 0.6
            circularSlider.cancelCountdownAnimation()
            
            timePickerView.isHidden = false
            timerLabel.isHidden = true
            endTimeStackView.isHidden = true
            circularSlider.isHidden = true
        }
    }
    
    private func addCircle() {
        circularSlider = CircularSliderView()
        timerView.addSubview(circularSlider)
        
        circularSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circularSlider.topAnchor.constraint(equalTo: timerView.centerYAnchor, constant: 20),
            circularSlider.leadingAnchor.constraint(equalTo: timerView.centerXAnchor),
            circularSlider.trailingAnchor.constraint(equalTo: timerView.trailingAnchor),
            circularSlider.bottomAnchor.constraint(equalTo: timerView.bottomAnchor)
        ])
    }
    
    private func formatEndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.string(from: timerModel.endTime!)
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
    
    func resetTimePickerView() {
        timePickerView.selectRow(0, inComponent: 0, animated: false)
        timePickerView.selectRow(0, inComponent: 1, animated: false)
        timePickerView.selectRow(0, inComponent: 2, animated: false)
    }
    
    @objc private func updateTimerLabel() {
        let minutes = Int(timerModel.initialTime) / 60
        let seconds = Int(timerModel.initialTime) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        timerLabel.font = .monospacedDigitSystemFont(ofSize: 70, weight: .thin)
        endTimeLabel.text = formatEndTime()
    }
    
    @objc private func changeStateToDefault() {
        setupUI(state: timerModel.state)
    }
    
    //MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if timerModel.state == .default {
            let selectedHours = timePickerView.selectedRow(inComponent: 0)
            let selectedMinutes = timePickerView.selectedRow(inComponent: 1)
            let selectedSeconds = timePickerView.selectedRow(inComponent: 2)
            
            let totalTimeInSeconds = TimeInterval(selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds)
            circularSlider.setCoundownTime(seconds: Int(totalTimeInSeconds))
            circularSlider.startCountdownAnimation()
            
            timerModel.start(withInitialTime: totalTimeInSeconds, alarmSound: "alarm_sound.mp3")
        } else if timerModel.state == .running {
            timerModel.pause()
            circularSlider.pauseCountdownAnimation()
        } else if timerModel.state == .paused {
            timerModel.resume()
            circularSlider.resumeCountdownAnimation()
        }
        
        setupUI(state: timerModel.state)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        timerModel.stop()
        //resetTimePickerView()
        timePickerView.isHidden = false
        timerLabel.isHidden = true
        endTimeStackView.isHidden = true
        
        setupUI(state: .default)

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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHours = timePickerView.selectedRow(inComponent: 0)
        let selectedMinutes = timePickerView.selectedRow(inComponent: 1)
        let selectedSeconds = timePickerView.selectedRow(inComponent: 2)

        if selectedHours == 0 && selectedMinutes == 0 && selectedSeconds == 0 {
            startButton.isEnabled = false
            startButton.alpha = 0.6
        } else {
            startButton.isEnabled = true
            startButton.alpha = 1.0
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
