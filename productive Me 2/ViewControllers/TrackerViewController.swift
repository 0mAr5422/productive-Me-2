//
//  TrackerViewController.swift
//  productive Me 2
//
//  Created by omar on 10/23/19.
//  Copyright © 2019 omar. All rights reserved.
//

import UIKit
import MobileCoreServices


class TrackerViewController: UIViewController {
    

    
    
    
    var tappedCellIndexForSegueTransition : IndexPath?
    
    var collectionView : UICollectionView! = nil
    
    let userDefaults = UserDefaults.standard
    var taskToTrack : [[String]] = [
        ["push-ups","30","30"] ,
        ["asd" , "55" , "568"] ,
        ["pull-uos" , "10"  , "100"] ,
        ["chin-ups" , "8" , "200"],
        ["push-ups","30","30"] ,
        ["asd" , "55" , "568"]
        
    ]
    static let saveKeyForTasksToTrack = "save-key-for-tasks-to-track-tracker-view-controller"
    
    
    
    @IBOutlet weak var addNewTaskToTrackBarButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        if (userDefaults.array(forKey: TrackerViewController.saveKeyForTasksToTrack) != nil) {
            taskToTrack = userDefaults.array(forKey: TrackerViewController.saveKeyForTasksToTrack) as! [[String]]
        }
        else {
            taskToTrack = [
                ["push-ups","30","30"] ,
                ["meditation" , "30" , "50"]
                
            ]
            userDefaults.set(taskToTrack, forKey: TrackerViewController.saveKeyForTasksToTrack)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Track"
        view.backgroundColor = .white
        configureCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHasBeenSendFromExpandedCellView) , name: .init("reloadDataInTrackerViewController"), object: nil)
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        
    }
    @IBAction func addNewTaskToTrackBarButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowNewTaskConfigurationView", sender: nil)
    }
    
   @objc func notificationHasBeenSendFromExpandedCellView() {
    taskToTrack = userDefaults.array(forKey: TrackerViewController.saveKeyForTasksToTrack) as! [[String]]
    self.collectionView.reloadItems(at: [tappedCellIndexForSegueTransition!])
    
    }
    
}



extension TrackerViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex : Int , layoutEnvironment : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            let leadingAboveItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.40))
            let leadingAboveItem = NSCollectionLayoutItem(layoutSize: leadingAboveItemSize)
            
            let leadingDownItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.60))
            let leadingDownItem = NSCollectionLayoutItem(layoutSize: leadingDownItemSize)
            
            let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitems: [leadingAboveItem, leadingDownItem])
            
            let trailingAboveItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.55))
            let trailingAboveItem = NSCollectionLayoutItem(layoutSize: trailingAboveItemSize)
            
            let trailingDownItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.45))
            let trailingDownItem = NSCollectionLayoutItem(layoutSize: trailingDownItemSize)
            
            let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, subitems: [trailingAboveItem , trailingDownItem])
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup , trailingGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
           
            return section
            
            
            
        }
        return layout
    }
}

extension TrackerViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            
            
        ])
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCellForTracking.self, forCellWithReuseIdentifier: CustomCellForTracking.reuseIdentifier)
    }
    
    
        
        
        
   
}



extension TrackerViewController : CollectionViewCellDelegate {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellExpanded" {
            let destinationVC = segue.destination as? ExpandedCellViewController
            destinationVC?.cellName = taskToTrack[tappedCellIndexForSegueTransition!.item][0]
            destinationVC?.cellCurrentProgress = Int(taskToTrack[tappedCellIndexForSegueTransition!.item][1])!
            destinationVC?.cellGoal = Int(taskToTrack[tappedCellIndexForSegueTransition!.item][2])!
            destinationVC?.indexPath = tappedCellIndexForSegueTransition!
        }
    }
    
    func addButtonWasTappedInCell(_ button: UIButton , _ cell : UICollectionViewCell) {
        
        let index = collectionView.indexPath(for: cell)
        var current = Int(taskToTrack[index!.item][1])
        let goal = Int(taskToTrack[index!.item][2])
        if current! < goal! {
            current! += 1
            taskToTrack[index!.item][1] = String(current!)
            userDefaults.set(taskToTrack, forKey: TrackerViewController.saveKeyForTasksToTrack)
            self.collectionView.reloadItems(at: [index!])
        }
        else {
            print("you already reached your goal")
        }
        
    }
    
    func cellWasTapped(_ cell: UICollectionViewCell) {
        tappedCellIndexForSegueTransition = collectionView.indexPath(for: cell)
        
        performSegue(withIdentifier: "cellExpanded", sender: nil)
       
    }
    
    
    
}

// here i am just comfronting my UIviewController to tthe collectionViewDelegate
extension TrackerViewController : UICollectionViewDelegate {
    
}

extension TrackerViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskToTrack.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCellForTracking.reuseIdentifier, for: indexPath) as? CustomCellForTracking else {fatalError("wrong check cell registeration ") }
        cell.collectionViewCellDelegate = self
        let identifier = taskToTrack[indexPath.item]
        let cellGoal = identifier[2]
        let cellCurrent = identifier[1]
        let percentage = Double(Double(cellCurrent)! / Double(cellGoal)!) * 100
        
        
        cell.label.text = identifier[0]
        if percentage >= 100 {
            cell.progress.text = "You reached your goal of \(cellGoal)"
        }
        else {
            cell.progress.text = "Your Goal is \(cellGoal)"
        }
        cell.percentageLabel.text = "\(Int(percentage))%"
        cell.shapeLayer.frame.size.width = cell.trackLayer.frame.width * CGFloat(percentage/100)
        if percentage >= 100 {
            UIView.animate(withDuration: 0.5, animations: {
                cell.isCompletedIndicator.alpha = 1
                cell.isCompletedIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { (bool) in
                UIView.animate(withDuration: 0.5, animations:  {
                    cell.isCompletedIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) {(bool) in
                    UIView.animate(withDuration: 0.5) {
                        cell.isCompletedIndicator.transform = .identity
                    }
                }
            }
        }
        else {
            cell.isCompletedIndicator.alpha = 0
        }
        
        return cell
    }
    
    
}

extension TrackerViewController : UICollectionViewDropDelegate , UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
            let data = taskToTrack[indexPath.item]
            let itemProvider = NSItemProvider()

            let mutableData = NSMutableData()
        for string in data  {
            if let stringData = string.data(using: .utf8) {
                let divider = "*"
                let dividerData = divider.data(using: .utf8)!
                mutableData.append(stringData)
                mutableData.append(dividerData)

            } else {

                NSLog("Uh oh, trouble!")

            }
        }
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String  , visibility: .all) { completion in
                completion(mutableData as Data, nil)
                return nil
            }

             return [
                       UIDragItem(itemProvider: itemProvider)
                   ]
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            if session.items.count > 1 {
                return UICollectionViewDropProposal(operation: .cancel)
            } else {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
         let destinationIndexPath: IndexPath
            
            print("this is me in collection view")
        
               if let indexPath = coordinator.destinationIndexPath {
                   destinationIndexPath = indexPath
               } else {
                   let section = collectionView.numberOfSections - 1
                   let item = collectionView.numberOfItems(inSection: section)
                   destinationIndexPath = IndexPath(item: item, section: section)
               }
               
               coordinator.session.loadObjects(ofClass: NSString.self) { items in
                let stringItems = items as! [String]
                
                var trueTask : [String] = []
                for s in stringItems {
                    var word = ""
                    for c in s {
                        if c != "*" {
                            word.append(c)
                        }
                        else {
                            if word.count > 0 {
                                trueTask.append(word)
                                word = ""
                            }
                            else {continue}
                            
                        }
                    }
                }
                
                var trueee : [[String]] = []
               
                trueee.append(trueTask)
                   
                
              
                
                var indexPaths = [IndexPath]()
                
               for (index, array) in trueee.enumerated() {
                    
               
                }


                collectionView.insertItems(at: indexPaths)
                collectionView.reloadData()
               }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    
}



