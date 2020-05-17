//
//  ExpandedCellViewController.swift
//  productive Me 2
//
//  Created by omar on 10/25/19.
//  Copyright © 2019 omar. All rights reserved.
//

import UIKit
import AVFoundation
class ExpandedCellViewController: UIViewController {
    var audioPlayer : AVAudioPlayer?
    let cellNameLabel = UILabel()
    let progressPercentageLabel = UILabel()
    let stepper = UIStepper()
    let isCompletedIndicator = UIImageView()
    
    var cellName = "cellName"
    var cellProgressPercentage : Double = 54.5
    var cellCurrentProgress = 0
    var cellGoal = 0
    
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    
    var indexPath : IndexPath?
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataInTrackerViewController") , object: nil )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        view.addSubview(cellNameLabel)
        view.addSubview(progressPercentageLabel)
        view.addSubview(stepper)
        view.addSubview(isCompletedIndicator)
        configureNameLabel()
        configureProgressCircularShape()
        configureProgressPercentageLabel()
        configureTheStepper()
        configureCompletionIndicatorImage()
        stepper.value = Double(cellCurrentProgress)
    }
    

}

extension ExpandedCellViewController {
    private func configureNameLabel (){
        cellNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            cellNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            cellNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            cellNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            cellNameLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        cellNameLabel.textColor = .black
        cellNameLabel.textAlignment = .left
        cellNameLabel.text = cellName
        cellNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    private func configureProgressPercentageLabel() {
        cellProgressPercentage  = Double(Double(cellCurrentProgress) / Double(cellGoal) * 100)
        progressPercentageLabel.text = "\(Int(cellProgressPercentage))% Completed"
        progressPercentageLabel.numberOfLines = 0
        progressPercentageLabel.textColor = .black
        progressPercentageLabel.font = UIFont.boldSystemFont(ofSize: 22)
        progressPercentageLabel.textAlignment = .center
        progressPercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressPercentageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120 + 75),
            progressPercentageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width / 2) - (125 / 2)),
            progressPercentageLabel.widthAnchor.constraint(equalToConstant: 125),
            progressPercentageLabel.heightAnchor.constraint(equalToConstant: 75)
            
        ])
    }
    
    private func configureTheStepper() {
        stepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            stepper.topAnchor.constraint(equalTo: progressPercentageLabel.bottomAnchor, constant: 125),
            stepper.leadingAnchor.constraint(equalTo: progressPercentageLabel.leadingAnchor, constant: 12.5),
            stepper.heightAnchor.constraint(equalToConstant: 75),
            stepper.widthAnchor.constraint(equalToConstant: 150)
            
        ])
        stepper.addTarget(self, action: #selector(handleStepper(_:)), for: .touchUpInside)
    }
    private func configureCompletionIndicatorImage() {
       isCompletedIndicator.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
       
           isCompletedIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
           isCompletedIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
           isCompletedIndicator.heightAnchor.constraint(equalToConstant: 40),
           isCompletedIndicator.widthAnchor.constraint(equalToConstant: 40)
       
       ])
       isCompletedIndicator.image = UIImage(systemName: "checkmark.circle.fill")
       isCompletedIndicator.tintColor = .systemGreen
        isCompletedIndicator.contentMode = .scaleAspectFit
        if(cellProgressPercentage >= 100) {
            isCompletedIndicator.alpha = 1
        }
        else {
            isCompletedIndicator.alpha = 0
        }
   }
}

extension ExpandedCellViewController {
    @objc func handleStepper(_ sender : UIStepper) {
        sender.stepValue = 1
        sender.minimumValue = 0
        sender.maximumValue = Double(cellGoal)
        cellCurrentProgress = Int(sender.value)
        cellProgressPercentage  = Double(Double(cellCurrentProgress) / Double(cellGoal) * 100)
        progressPercentageLabel.text = "\(Int(cellProgressPercentage))% Completed"
        
        progressLayer.strokeEnd = CGFloat(CGFloat(cellCurrentProgress) / CGFloat(cellGoal))
        
        var tasksToTrack = UserDefaults.standard.array(forKey: TrackerViewController.saveKeyForTasksToTrack) as! [[String]]
        tasksToTrack[indexPath!.item][1] = String(cellCurrentProgress)
        UserDefaults.standard.set(tasksToTrack, forKey: TrackerViewController.saveKeyForTasksToTrack)
        playSound()
    }
}

extension ExpandedCellViewController {
    fileprivate func configureProgressCircularShape() {
        trackLayer.path = UIBezierPath(roundedRect: CGRect(x: 60, y: 120, width: 250, height: 250), cornerRadius: 125).cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.strokeEnd = 1
        trackLayer.lineWidth = 15
        
        progressLayer.path = trackLayer.path
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemOrange.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 15
        progressLayer.strokeEnd = 0
        
        
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(progressLayer)
        
        progressLayer.add(animateStrokeOfProgressLayer(), forKey: "123")
        progressLayer.strokeEnd = CGFloat(CGFloat(cellCurrentProgress) / CGFloat(cellGoal))
    }
    fileprivate func  animateStrokeOfProgressLayer() -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.fromValue = 0
        animation.toValue = CGFloat(CGFloat(cellCurrentProgress) / CGFloat(cellGoal))
        return animation
    }
}



// the function that will play the sound everytime you add or remove value to the progress
extension ExpandedCellViewController {
    func playSound() {
        guard let url = Bundle.main.url(forResource: "tick", withExtension: "mp3") else {return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = audioPlayer else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
            print("shdbf")
        }
    }
}
