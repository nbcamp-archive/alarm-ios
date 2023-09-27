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
        
        resetView.circleView = true
        resetButton.circleButton = true

        startView.circleView = true
        startButton.circleButton = true
        
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


    //MARK: - TimerHandler
    
    @objc private func updateTime(){
        stopWatch.update()
        
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = stopWatchCollectionView.cellForItem(at: indexPath) {
            if let label = cell.subviews.compactMap({ $0 as? UILabel }).first {
                label.text = stopWatch.time
            }
        }
        
        stopWatchTableView.cellForRow(at: .init(row: 0, section: 0))?.detailTextLabel?.text = stopWatch.lapTime
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

extension StopWatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewcell", for: indexPath)
        
        //FIXME: 이렇게 말고 이미 존재하면 새로 생성 안하도록 조건 처리
        if let existingLabel = cell.subviews.first(where: { $0 is UILabel }) {
            existingLabel.removeFromSuperview()
        }
        
        if indexPath.row == 0 {
            let label = UILabel(frame: cell.bounds)
            label.text = stopWatch.time
            label.font = .monospacedDigitSystemFont(ofSize: 80, weight: .thin)

            cell.addSubview(label)
        }

        //FIXME: 아날로그 시계 생성하기
        if indexPath.row == 1 {
            let button = UIButton(type: .system)
            button.frame = cell.contentView.bounds
            button.setTitle("버튼", for: .normal)
            cell.contentView.addSubview(button)
        }
        
        return cell
    }
}

extension StopWatchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
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
                    cell.detailTextLabel?.textColor = .green
                    cell.textLabel?.textColor = .green
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
