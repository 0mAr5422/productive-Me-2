//
//  CustomTableCellForToDo.swift
//  productive Me 2
//
//  Created by omar on 10/23/19.
//  Copyright © 2019 omar. All rights reserved.
//
import UIKit


class CustomTableCellForToDo : UITableViewCell {

        
    let label = UILabel()
    let view = UIView()
    let tagView = UIView()
    let shapeLayer = CAShapeLayer()
    var viewConstraint : [NSLayoutConstraint] = []
    static let reuseIdentifier = "Reuse-id-for-customized-tableview-cell-for-todo"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(view)
    }
    
    
    
    func animateCompletion () {
        
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), cornerRadius: 4).cgPath
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.init(red: 220/255, green: 83/255, blue: 83/255, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeStart = 0
        view.layer.addSublayer(shapeLayer)
        shapeLayer.add(applyStrokeAnimation(), forKey: "125467")
    }
    
    fileprivate func applyStrokeAnimation() -> CABasicAnimation{
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0;
        strokeAnimation.toValue = 1;
        strokeAnimation.repeatCount = 1;
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.duration = 0.5;
        
        return strokeAnimation
    }
    
    func removeShapeLayerFromCellAfterCompletion() {
        shapeLayer.removeFromSuperlayer()
    }
    required init?(coder: NSCoder) {
        fatalError("fatal error ")
    }
}


// configuring the view of the cell which will contain the tag view and the label

extension CustomTableCellForToDo {
    func configure(isCompleted : Bool) {
        if isCompleted {
            configureView(isCompleted: true)
        }
        else {
            configureView(isCompleted: false)
        }
    }
}



extension CustomTableCellForToDo {
    private func configureView(isCompleted : Bool) {
        
           view.addSubview(tagView)
           view.addSubview(label)
           view.bringSubviewToFront(label)
           
           view.translatesAutoresizingMaskIntoConstraints  = false
            viewConstraint = [
               (view.topAnchor.constraint(equalTo: topAnchor, constant: 5)),
               (view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)),
               (view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)),
               (view.widthAnchor.constraint(equalTo: widthAnchor, constant: -10))
           ]
           NSLayoutConstraint.activate(viewConstraint)
        view.backgroundColor = .clear
        
           view.layer.cornerRadius = 10
           view.layer.shadowColor = UIColor.clear.cgColor
           view.layer.shadowOffset = CGSize(width: 2, height: 2)
           view.layer.shadowOpacity = 1
           view.layer.borderColor = UIColor.lightGray.cgColor
           configureTagView(isCompleted: isCompleted)
           configureNameLabel(isCompleted: isCompleted)
    }
    
    private func configureTagView(isCompleted : Bool) {
           tagView.translatesAutoresizingMaskIntoConstraints = false
           let tagViewConstraints : [NSLayoutConstraint] = [
               (tagView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)),
               (tagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1)),
               (tagView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)),
               (tagView.widthAnchor.constraint(equalToConstant: 5))
           ]
           NSLayoutConstraint.activate(tagViewConstraints)
           tagView.layer.cornerRadius = 5
            
        if isCompleted {
            tagView.backgroundColor = .init(red: 220/255, green: 83/255, blue: 83/255, alpha: 1)
        }
        else {tagView.backgroundColor = .systemOrange}
    }
    
    private func configureNameLabel(isCompleted : Bool) {
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints  = false
        let labelConstraints : [NSLayoutConstraint] = [
            (label.topAnchor.constraint(equalTo: topAnchor, constant: 5)),
            (label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)),
            (label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)),
            (label.widthAnchor.constraint(equalTo: widthAnchor, constant: -10))
        ]
        NSLayoutConstraint.activate(labelConstraints)
        if isCompleted {
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 14)
        }
        else {label.textColor = .black}
    }
}


extension CustomTableCellForToDo {
    
    
    
    
}
