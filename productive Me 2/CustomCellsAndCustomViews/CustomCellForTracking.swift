//
//  CustomCellForTracking.swift
//  productive Me 2
//
//  Created by omar on 10/23/19.
//  Copyright © 2019 omar. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func cellWasTapped(_ cell: UICollectionViewCell)
    func addButtonWasTappedInCell (_ button : UIButton , _ cell: UICollectionViewCell)
}

class CustomCellForTracking: UICollectionViewCell {
    
    static let reuseIdentifier = "Custom-Collection-View-Cell-For-Tracking"
    weak var collectionViewCellDelegate : CollectionViewCellDelegate?
    
    
    let view = UIView()
    let label = UILabel()
    let isCompletedIndicator = UIImageView()
    let trackLayer = CALayer()
    let shapeLayer = CALayer()
    
    let progress = UILabel();
    let addProgressButton = UIButton(type: .system);
    
   
    
    let percentageLabel = UILabel();

    
    
    let lineLayer = CALayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(view)
        view.addSubview(label)
        view.addSubview(progress)
        view.addSubview(addProgressButton)
        view.addSubview(percentageLabel)
        view.addSubview(isCompletedIndicator)
        configureView()
        configureLabel()
        createShapeLayersForTracking()
        configureAddProgressButton()
        configurePercentageLabel()
        configureProgressLabel()
        configureCompletionIndicatorImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("wrong Wrong WRONG!!!!")
    }
}

extension CustomCellForTracking {
    func configureView() {
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
    }
    
    func configureLabel() {
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 24)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            label.heightAnchor.constraint(equalToConstant: 75),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-5),
        ])
    }
    
    func configureProgressLabel () {
        progress.text = "Your Goal is 100"
        progress.font = UIFont.boldSystemFont(ofSize: 16)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.textAlignment = .left
        progress.numberOfLines = 1
        progress.textColor = .black
        progress.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: percentageLabel.topAnchor, constant: 25),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            progress.heightAnchor.constraint(equalToConstant: 50),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-5),
            
        ])
        
        
    }
    func configurePercentageLabel() {
        percentageLabel.text = "75%"
        percentageLabel.textColor = .black
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 22)
        percentageLabel.numberOfLines = 2
        percentageLabel.textAlignment = .left
        percentageLabel.translatesAutoresizingMaskIntoConstraints  = false
        let percentageLabelConstraints : [NSLayoutConstraint] = [
            (percentageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90)),
            (percentageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)),
            (percentageLabel.heightAnchor.constraint(equalToConstant: 50)),
            (percentageLabel.widthAnchor.constraint(equalToConstant: 75))
        ]
        NSLayoutConstraint.activate(percentageLabelConstraints)
        
    }
    func configureAddProgressButton() {
           
           
        addProgressButton.translatesAutoresizingMaskIntoConstraints = false
        addProgressButton.setTitle("Quick Add +", for: .normal)
        addProgressButton.setTitleColor(.systemOrange, for: .normal)
        addProgressButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        NSLayoutConstraint.activate([
           
           addProgressButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
           addProgressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
           addProgressButton.heightAnchor.constraint(equalToConstant: 25),
           addProgressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-10),
           
        ])
        addProgressButton.addTarget(self, action: #selector(addButtonPressedInCell(_:)), for: .touchUpInside)
           
    }
    
    func configureCompletionIndicatorImage() {
        isCompletedIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            isCompletedIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            isCompletedIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            isCompletedIndicator.heightAnchor.constraint(equalToConstant: 25),
            isCompletedIndicator.widthAnchor.constraint(equalToConstant: 25)
        
        ])
        isCompletedIndicator.image = UIImage(systemName: "checkmark.circle.fill")
        isCompletedIndicator.tintColor = .systemOrange
        isCompletedIndicator.alpha = 0
    }
}



extension CustomCellForTracking {
    @objc fileprivate func addButtonPressedInCell (_ sender : UIButton) {
        self.collectionViewCellDelegate?.addButtonWasTappedInCell(sender, self)
    }
}

extension CustomCellForTracking {
    fileprivate func createShapeLayersForTracking() {
        
        
        
        trackLayer.backgroundColor = UIColor.init(red: 233/255, green: 229/255, blue: 221/255, alpha: 1).cgColor
        trackLayer.frame = CGRect(x: 15, y: 80, width: 150, height: 5)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.backgroundColor = UIColor.systemOrange.cgColor
        shapeLayer.frame = CGRect(x: 15, y: 80, width: 125, height: 5)
        view.layer.addSublayer(shapeLayer)
        
        
        
    }
}
extension CustomCellForTracking {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          UIView.animate(withDuration: 0.2) {
              self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
          }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

           UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
        
        self.collectionViewCellDelegate?.cellWasTapped(self )
        
                 
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
            
        }
    }
    
    
}
