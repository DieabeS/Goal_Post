//
//  FinishGoalVC.swift
//  goal post app
//
//  Created by medicusMac on 8/19/22.
//

import UIKit

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var createGoalBtn: UIButton!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    func initData(
        description: String,
        type: GoalType
    ) {
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyboard()
        pointsTextField.delegate = self
    }
    
    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        if self.pointsTextField.text != "" {
            self.save{ (complete) in
                if complete {
                    //to pop to specific viewController
//                    guard let goalVC = navigationController?.viewControllers.first(where: { $0 is GoalsVC}) as? GoalsVC else { return }
//
//                    navigationController?.popToViewController(goalVC, animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    private func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appdelegate?.persistentContainer.viewContext
        else {
            return
        }
        
        let goal = Goal(context: managedContext)
        goal.goalDescription = self.goalDescription
        goal.goalType = self.goalType.rawValue
        goal.goalCompletionValue = Int32(self.pointsTextField.text!)!
        goal.goalProgress = Int32(0)
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Coudln't save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
