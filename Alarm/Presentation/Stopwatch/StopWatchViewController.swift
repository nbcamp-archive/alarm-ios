//
//  StopWatchViewController.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/25.
//

import UIKit

class StopWatchViewController: BaseUIViewController {
    
    weak var coordinator: StopWatchViewCoordinator?
    
    override func setTitle() {
        title = "스톱워치"
    }
    
    //MARK: - Properties
    
    private let stopWatch = StopWatch()
    private weak var timer :Timer?
    
    private var timeHandLayer: CAShapeLayer!
    private var lapTimeHandLayer: CAShapeLayer!
    
    private var analogFaceImageView = UIImageView(image: UIImage(named: "analogStopwatch"))

    
    //MARK: - Outlets
    
    @IBOutlet weak var stopWatchCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var startView: UIView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopWatchTableView: UITableView!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME: - 컴포넌트들 색상 투명도 테스트용 -> 지우기
        self.view.backgroundColor = UIColor(hex: "#A4CAF5")
        
        stopWatchCollectionView.backgroundColor = .clear
        
        resetView.circleView = true
        resetButton.circleButton = true

        startView.circleView = true
        startButton.circleButton = true
        
        lapTimeHandLayer = createClockHandLayer(length: 145, thickness: 3, color: UIColor.systemBlue.cgColor, angle: CGFloat(stopWatch.lapCount) * 0.06)
        timeHandLayer = createClockHandLayer(length: 145, thickness: 3, color: UIColor.systemOrange.cgColor, angle: CGFloat(stopWatch.count) * 0.06)
        
        switchButtonsAppearance(state: stopWatch.state)
    }
    
    
    //MARK: - Actions
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        stopWatchCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if timer == nil {
            timer = .scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
            stopWatch.start()
            
            self.stopWatchTableView.reloadData()
        } else {
            timer?.invalidate()
            timer = nil
            stopWatch.stop()
        }

        switchButtonsAppearance(state: stopWatch.state)
        
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        switch stopWatch.state {
        case .valid:
            stopWatch.add()
            stopWatchTableView.reloadData()
        case .invalid:
            stopWatch.reset()
            stopWatchTableView.reloadData()
            let indexPath = IndexPath(item: 0, section: 0)
            if let cell = stopWatchCollectionView.cellForItem(at: indexPath) {
                if let label = cell.subviews.compactMap({ $0 as? UILabel }).first {
                    label.text = stopWatch.time
                }
            }
            let indexPath2 = IndexPath(item: 1, section: 0)
            if let cell = stopWatchCollectionView.cellForItem(at: indexPath2) {
                if let label = cell.subviews.compactMap({ $0 as? UILabel }).first {
                    label.text = stopWatch.time
                }
            }
            updateClockHands()
            switchButtonsAppearance(state: stopWatch.state)
        default: break
        }
    }
    
    
    //MARK: - Appearance
    
    private func switchButtonsAppearance(state: StopWatch.State ){
        switch state {
        case .valid:
            startButton.setTitle("중단", for: .normal)
            startButton.backgroundColor = UIColor(named: "StopBackground")
            startButton.setTitleColor(UIColor(named: "StopText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StopBackground")
            resetButton.setTitle("랩", for: .normal)
            resetButton.alpha = 1
        case .invalid:
            startButton.setTitle("시작", for: .normal)
            startButton.backgroundColor = UIColor(named: "StartBackground")
            startButton.setTitleColor(UIColor(named: "StartText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StartBackground")
            resetButton.setTitle("재설정", for: .normal)
        case .default:
            startButton.setTitle("시작", for: .normal)
            startButton.backgroundColor = UIColor(named: "StartBackground")
            startButton.setTitleColor(UIColor(named: "StartText"), for: .normal)
            startView.backgroundColor = UIColor(named: "StartBackground")
            resetButton.setTitle("랩", for: .normal)
            resetButton.alpha = 0.6
        }
    }
    
    //MARK: - Analog face
    
    private func createClockHandLayer(length: CGFloat, thickness: CGFloat, color: CGColor, angle: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: length, y: length))
        path.addLine(to: CGPoint(x: length, y: 0))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = thickness
        layer.lineCap = .round
        layer.bounds = CGRect(x: 0, y: 0, width: length * 2, height: length * 2)
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        layer.transform = CATransform3DMakeRotation(angle.toRadians, 0, 0, 1)
        
        return layer
    }
    
    private func updateClockHands() {
        let timeAngle = CGFloat(stopWatch.count) * 0.06
        let lapTimeAngle = CGFloat(stopWatch.lapCount) * 0.06
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.01)
        
        timeHandLayer.transform = CATransform3DMakeRotation(timeAngle.toRadians, 0, 0, 1)
        lapTimeHandLayer.transform = CATransform3DMakeRotation(lapTimeAngle.toRadians, 0, 0, 1)
        
        CATransaction.commit()
    }


    //MARK: - TimerHandler
    
    @objc private func updateTime(){
        stopWatch.update()
        
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = stopWatchCollectionView.cellForItem(at: indexPath) {
            if let label = cell.subviews.compactMap({ $0 as? UILabel }).first {
                label.text = stopWatch.time
            }
        }
        
        let indexPath2 = IndexPath(item: 1, section: 0)
        if let cell = stopWatchCollectionView.cellForItem(at: indexPath2) {
            if let label = cell.subviews.compactMap({ $0 as? UILabel }).first {
                label.text = stopWatch.time
            }
        }
        
        stopWatchTableView.cellForRow(at: .init(row: 0, section: 0))?.detailTextLabel?.text = stopWatch.lapTime
        
        if let timeHandLayer = timeHandLayer {
            updateClockHands()
        }
    }
    
}


//MARK: - UIScrollViewDelegate

extension StopWatchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width / 2.0)
        
        let newPage = Int(x / width)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}


//MARK: - UICollectionView

extension StopWatchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension StopWatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewcell", for: indexPath)
        cell.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            cell.contentView.widthAnchor.constraint(equalToConstant: 330),
            cell.contentView.heightAnchor.constraint(equalToConstant: 330),
            cell.contentView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            cell.contentView.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        
        //FIXME: 이렇게 말고 이미 존재하면 새로 생성 안하도록 조건 처리
        if let existingLabel = cell.subviews.first(where: { $0 is UILabel }) {
            existingLabel.removeFromSuperview()
        }
        if let existingLabel = cell.subviews.first(where: { $0 is UILabel }) {
            existingLabel.removeFromSuperview()
        }
        
        if indexPath.row == 0 {
            let label = UILabel(frame: cell.bounds)
            label.text = stopWatch.time
            label.font = .monospacedDigitSystemFont(ofSize: 80, weight: .thin)
            label.textAlignment = .center
            
            //TODO: - label 배경 반투명하게 하는 게 좋을지, 없는 게 좋을지...
            let whiteColor = UIColor.white
            label.layer.backgroundColor = whiteColor.withAlphaComponent(0.3).cgColor
            //label.layer.borderColor = whiteColor.withAlphaComponent(0.3).cgColor
            label.layer.cornerRadius = 10
            //label.layer.borderWidth = 2


            cell.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                label.heightAnchor.constraint(equalToConstant: 216),
                label.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1.0)
            ])
            

        }

        if indexPath.row == 1 {
            let clockCenter = cell.contentView.center
            
            cell.contentView.addSubview(analogFaceImageView)
            analogFaceImageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                analogFaceImageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                analogFaceImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
                analogFaceImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                analogFaceImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10)
            ])
            
            let label = UILabel(frame: cell.bounds)
            label.text = stopWatch.time
            label.font = .monospacedDigitSystemFont(ofSize: 20, weight: .regular)
            label.textAlignment = .center
            cell.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                label.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -100)
            ])
            
            lapTimeHandLayer.position = clockCenter
            cell.layer.addSublayer(lapTimeHandLayer)
            
            timeHandLayer.position = clockCenter
            cell.layer.addSublayer(timeHandLayer)
        }
        
        return cell
    }
}


//MARK: - UITableView

extension StopWatchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch stopWatch.state {
        case .default: return 0
        default: return stopWatch.laps.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1 , reuseIdentifier: "cell")
        
        cell.backgroundColor = .clear
        let whiteColor = UIColor.white
        cell.layer.backgroundColor = whiteColor.withAlphaComponent(0.3).cgColor

        cell.textLabel?.text = "랩 \(stopWatch.laps.count - indexPath.row + 1)"
        cell.detailTextLabel?.textColor = .black

        cell.selectionStyle = .none
        
        if indexPath.row != 0 {
            cell.detailTextLabel?.text = stopWatch.laps[indexPath.row - 1]
        } else {
            cell.detailTextLabel?.text = stopWatch.lapTime
        }
        
        if stopWatch.laps.count > 1 {
            if let minIndex = stopWatch.shortTimeIndex, let maxIndex = stopWatch.longTimeIndex {
                switch indexPath.row {
                case minIndex + 1:
                    cell.detailTextLabel?.textColor = .systemGreen
                    cell.textLabel?.textColor = .systemGreen
                case maxIndex + 1:
                    cell.detailTextLabel?.textColor = .red
                    cell.textLabel?.textColor = .red
                default: break
                }
            }
        }
        return cell
    }
}

extension StopWatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44.0
    }
}

extension CGFloat {
    var toRadians: CGFloat {
        return self * .pi / 180.0
    }
}

extension Double {
    var toRadians: CGFloat {
        return CGFloat(self) * CGFloat.pi / 180
    }
}
