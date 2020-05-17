//
//  ViewController.swift
//  productive Me 2
//
//  Created by omar on 10/23/19.
//  Copyright © 2019 omar. All rights reserved.
//

import UIKit
import MobileCoreServices


class ToDoListViewController: UIViewController  {
    let userDefaults = UserDefaults.standard
    let saveKeyForTheListOfTasksToDo = "save-key-for-list-of-tasks-to-do"
    let saveKeyForTheListOfCompletedTasks = "save-key-for-the-completed-tasks"
    var toDoS : [String] = []
    var completedToDos : [String] = []
    let textField = UITextField()
    var bottomConstraintForTextField : NSLayoutConstraint = NSLayoutConstraint()
    var beganEditing = false;
    var longPress = UILongPressGestureRecognizer()
    
    @IBOutlet weak var addNewTaskButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewTaskBarButton: UIBarButtonItem!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if((userDefaults.array(forKey: saveKeyForTheListOfTasksToDo)) != nil){
            toDoS = userDefaults.array(forKey: saveKeyForTheListOfTasksToDo) as! [String]
            
        }
        else {
            toDoS = ["you can use the add button to add new tasks" , "press on a task to mark it as complete "]
            
        }
        if ((userDefaults.array(forKey: saveKeyForTheListOfCompletedTasks)) != nil) {
            completedToDos = userDefaults.array(forKey: saveKeyForTheListOfCompletedTasks) as! [String]
        }
        else {
            completedToDos = ["swipe a task to the left to delete"]
        }
    }
    
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        
        navigationItem.title = "Today"
        
        configureTableView()
        configureAddButton()
        createInputTextField()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    

    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        textField.becomeFirstResponder()

    }
    
    @IBAction func addNewTaskButton(_ sender: UIButton) {
        textField.becomeFirstResponder()
        
    }
    
    
    
    
}




extension ToDoListViewController : UITextFieldDelegate {
      @objc func keyboardWillShow(notification:NSNotification) {
        adjustHeight(show: true, notification: notification)
        addNewTaskButton.isEnabled = false
        addNewTaskBarButton.isEnabled = false
                
      }
      @objc func keyboardWillHide(notification:NSNotification) {
          
       adjustHeight(show: false, notification: notification)
          addNewTaskButton.isEnabled = true
        addNewTaskBarButton.isEnabled = true
      }
       fileprivate func adjustHeight(show: Bool , notification : NSNotification){
                   
           let userInfo = notification.userInfo!
           let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
           let changeInHeight = (keyboardFrame.height )
           bottomConstraintForTextField.isActive = true
           if show {
               bottomConstraintForTextField.constant = -changeInHeight+10
               UIView.animate(withDuration: 0.5) {
                   self.view.layoutSubviews()
                self.tableView.alpha = 0.2
                self.navigationController?.navigationBar.alpha = 0.1
                self.navigationController?.navigationBar.backgroundColor = .systemGray2
                self.view.backgroundColor = .systemGray2
                self.tableView.isUserInteractionEnabled = false
               }
           }
           else {
            bottomConstraintForTextField.constant = 75
            
            UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
                self.tableView.alpha = 1
                self.navigationController?.navigationBar.alpha = 1
                self.navigationController?.navigationBar.backgroundColor = .white
                self.view.backgroundColor = .white
                self.tableView.isUserInteractionEnabled = true
            }
           }
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneNowAddTheNewTask()
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
    
    func doneNowAddTheNewTask (){
        let charset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        let stringFromTextField = textField.text
        if stringFromTextField != "" && ((stringFromTextField?.lowercased().rangeOfCharacter(from: charset)) != nil){
            toDoS.append(textField.text!)
            userDefaults.set(toDoS, forKey: saveKeyForTheListOfTasksToDo)
            tableView.reloadData()
        }
    }
}
extension UITextField {
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = (touches.first?.location(in: self.superview).y)!
        let centerY = self.center.y

        if  location > centerY {
            UIView.animate(withDuration: 0.1, animations: {
                self.center.y = location
            }) { (t) in
                self.resignFirstResponder()
            }





        }

    }

    func getMeOutOfHere() {
        print("i am out of here ")
    }
}

extension ToDoListViewController {
    
   
    private func createInputTextField() {
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.placeholder = "  ex : Finish my math assignment"
        textField.font = UIFont.boldSystemFont(ofSize: 15)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 15
        textField.textColor = .black
        textField.delegate = self
        let textFieldConstraints = [
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 75),
            textField.heightAnchor.constraint(equalToConstant: 85)
        ]
        bottomConstraintForTextField = textFieldConstraints[2]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
}

extension ToDoListViewController {
    private func configureAddButton() {
        addNewTaskButton.backgroundColor = .systemOrange
        addNewTaskButton.layer.cornerRadius = addNewTaskButton.frame.width/2
        addNewTaskButton.layer.shadowColor = UIColor.lightGray.cgColor
        addNewTaskButton.layer.shadowPath = CGPath(roundedRect: CGRect(x: 0, y: 0, width: 65, height: 65), cornerWidth: 60, cornerHeight: 60, transform: .none)
        addNewTaskButton.layer.shadowOpacity = 0.5
        view.bringSubviewToFront(addNewTaskButton)
    }
}

// configuring tableview to work with viewcontroller
extension ToDoListViewController {
    private func configureTableView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        tableView.backgroundColor = .white
        tableView.separatorColor = .gray
        tableView.rowHeight = 65
        tableView.sectionHeaderHeight = 45
        tableView.sectionIndexColor = .gray
        tableView.register(CustomTableCellForToDo.self, forCellReuseIdentifier: CustomTableCellForToDo.reuseIdentifier)
    }
    
    
    
    
    
}


extension ToDoListViewController : UITableViewDragDelegate , UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let placeName = indexPath.section == 0 ? toDoS[indexPath.row] : completedToDos[indexPath.row]

            let data = placeName.data(using: .utf8)
            let itemProvider = NSItemProvider()
            
            itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
                completion(data, nil)
                return nil
            }

             return [
                       UIDragItem(itemProvider: itemProvider)
                   ]
        
        
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
            

        } else {
            
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            // Consume drag items.
            let stringItems = items as! [String]
            
            
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                
                
                if let nn = self.toDoS.firstIndex(of: item)  {
                    
                }
                
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if destinationIndexPath.section == 0 {
                    self.toDoS.remove(at: index)
                    self.toDoS.insert(item, at: destinationIndexPath.row)
                    self.userDefaults.set(self.toDoS, forKey: self.saveKeyForTheListOfTasksToDo)
                }
                    
                else {
                    self.completedToDos.remove(at: index)
                    self.completedToDos.insert(item, at: destinationIndexPath.row)
                    self.userDefaults.set(self.completedToDos, forKey: self.saveKeyForTheListOfCompletedTasks)
                }
                indexPaths.append(indexPath)
            }

            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    
    
}

extension ToDoListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {return toDoS.count}
        else {return completedToDos.count}
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForToDo.reuseIdentifier) as? CustomTableCellForToDo else {fatalError("something went really wrong  ")}
        
        
        cell.addGestureRecognizer(self.longPress)
        
       
        
        if indexPath.section == 0 {
            cell.configure(isCompleted: false)
            cell.label.text = toDoS[indexPath.row]
            
        }
        else {
            cell.configure(isCompleted: true)
            cell.label.text = completedToDos[indexPath.row]
            
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {return "To Do"}
        else {return "completed"}
    }
    
}

extension ToDoListViewController : UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableCellForToDo
        if indexPath.section == 0 {
            let completedTask = cell.label.text
            cell.animateCompletion()
            UIView.animate(withDuration: 0.5, animations: {
                cell.label.alpha = 0
                cell.tagView.backgroundColor = UIColor.init(red: 220/255, green: 83/255, blue: 83/255, alpha: 1)
                tableView.deselectRow(at: indexPath, animated: true)
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    cell.removeShapeLayerFromCellAfterCompletion()
                    self.toDoS.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with:.bottom)
                    self.userDefaults.set(self.toDoS, forKey: self.saveKeyForTheListOfTasksToDo)
                }) { (true) in
                    self.completedToDos.append(completedTask!)
                    self.userDefaults.set(self.completedToDos, forKey: self.saveKeyForTheListOfCompletedTasks)
                    cell.label.alpha = 1
                    tableView.reloadData()
                }
                
            }
            
            
        }
        else {tableView.deselectRow(at: indexPath, animated: true)}
    }
    
  
       
       
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        if sourceIndexPath.section == 0 {
            let task = toDoS[sourceIndexPath.row]
            self.toDoS.remove(at: sourceIndexPath.row)
            if destinationIndexPath.section == 0 {
                self.toDoS.insert(task, at: destinationIndexPath.row)
            }
            else {
                self.completedToDos.insert(task, at: destinationIndexPath.row)
            }
            
            

        }
        else {
            let task = completedToDos[sourceIndexPath.row]
            self.completedToDos.remove(at: sourceIndexPath.row)
            if destinationIndexPath.section == 0 {
                self.toDoS.insert(task, at: destinationIndexPath.row)
            }
            else {
                self.completedToDos.insert(task, at: destinationIndexPath.row)
            }
            
        }
        self.userDefaults.set(self.toDoS, forKey: self.saveKeyForTheListOfTasksToDo)
        self.userDefaults.set(self.completedToDos, forKey: self.saveKeyForTheListOfCompletedTasks)
        
        self.tableView.reloadData()
        
        
        
        
    }
    
    
        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let inComplete = UIContextualAction(style: .normal, title: "InComplete") { (c, v, t) in
            
            guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableCellForToDo else {fatalError("wrong")}
            
            let task = self.completedToDos[indexPath.row]
            self.completedToDos.remove(at: indexPath.row)
            self.userDefaults.set(self.completedToDos, forKey: self.saveKeyForTheListOfCompletedTasks)
            
            
                NSLayoutConstraint.deactivate(cell.constraints)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.toDoS.append(task)
            
            self.userDefaults.set(self.toDoS, forKey: self.saveKeyForTheListOfTasksToDo)

            tableView.reloadData()
           
        }
        
            if indexPath.section == 0 {
                return nil
            }
        
        
        return UISwipeActionsConfiguration(actions: [inComplete])
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (c, v, t) in
            
            guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableCellForToDo else {fatalError("wrong")}
            
            if  indexPath.section == 0 {
                NSLayoutConstraint.deactivate(cell.constraints)
                self.toDoS.remove(at: indexPath.row)
                self.userDefaults.set(self.toDoS, forKey: self.saveKeyForTheListOfTasksToDo)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else  {
                self.completedToDos.remove(at: indexPath.row)
                self.userDefaults.set(self.completedToDos, forKey: self.saveKeyForTheListOfCompletedTasks)
                NSLayoutConstraint.deactivate(cell.constraints)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
   
}
