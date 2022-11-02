//
//  GoalsVC.swift
//  goal post app
//
//  Created by medicusMac on 8/15/22.
//

import UIKit
import CoreData


let appdelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var emptyGoalListStackView: UIStackView!
    @IBOutlet weak var goalTableView: UITableView!
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTableView.delegate = self
        goalTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCoreData()
    }


    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCreateGoalVC", sender: self)
    }
    
    @IBAction func unwindSegueAction(unwindSegueAction: UIStoryboardSegue) {
        
    }
    
    private func fetchCoreData() {
        self.fetch(completion: { complete in
            if complete && goals.count > 1 {
                self.goalTableView.isHidden = false
                self.emptyGoalListStackView.isHidden = true
            } else {
                self.goalTableView.isHidden = true
                self.emptyGoalListStackView.isHidden = false
            }
        })
        
        self.goalTableView.reloadData()
    }
    
}



// MARK: table view
extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = goalTableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell
        else {
            return UITableViewCell()
        }
        //cell.configureGoalCell(description: "eat salad for a week", type: .shortTerm , progressAmount: 2)
        let goal = goals[indexPath.row]
        cell.configureGoalCell(goal: goal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
    
            self.removeGoal(indexPath: indexPath)
            
            self.fetch { completed in
                if completed {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }

        let addAction = UITableViewRowAction(style: .destructive, title: "ADD") { (rowAction, indexPath) in
    
            self.setProgress(atIndexPath: indexPath)
            
            self.fetch { completed in
                if completed {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.6901960784, blue: 0.7803921569, alpha: 0.8465767159)


        return [deleteAction, addAction]
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UISwipeActionsConfiguration(actions: <#T##[UIContextualAction]#>)
//    }
//
//
//    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .destructive, title: "DELETE") { (action, view, nil) in
//
//            self.removeGoal(indexPath: indexPath)
//
//            self.fetch { completed in
//                if completed {
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                }
//            }
//
//        }
//        action.title = "Delete"
//        action.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//        return action
//    }
    
}



// MARK: Core data: managed object context
extension GoalsVC {
    func fetch(completion: (Bool) -> ()) {
        
        guard let managedObjectContext = appdelegate?.persistentContainer.viewContext else { return }
        
        let goalsFetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedObjectContext.fetch(goalsFetchRequest)
            completion(true)
        } catch {
            debugPrint("Couldn't fetch goals: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    
    func removeGoal(indexPath: IndexPath) {
        
        guard let managedObjectContext = appdelegate?.persistentContainer.viewContext else { return }
        
        managedObjectContext.delete(goals[indexPath.row])
        
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint("Couldn't remove goal: \(error.localizedDescription)")
        }
    }
    
    func setProgress(atIndexPath indexPath: IndexPath) {
        
        guard let managedObjectContext = appdelegate?.persistentContainer.viewContext else { return }
        
        let currentGoal = self.goals[indexPath.row]
        
        if currentGoal.goalProgress < currentGoal.goalCompletionValue {
            currentGoal.goalProgress += 1
        } else {
            return
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint("Couldn't remove goal: \(error.localizedDescription)")
        }
        
    }
}
