//
//  CreateGoalVC.swift
//  goal post app
//
//  Created by medicusMac on 8/19/22.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var createGoalTV: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.bindToKeyboard()
        createGoalTV.delegate = self
        shortTermBtn.selecetedColor()
        longTermBtn.deselectedColor()
    }

    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
        self.goalType = .shortTerm
        shortTermBtn.selecetedColor()
        longTermBtn.deselectedColor()
    }
    
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
        self.goalType = .longTerm
        self.longTermBtn.selecetedColor()
        self.shortTermBtn.deselectedColor()
    }
    
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        if createGoalTV.text != "" && createGoalTV.text != "What is your goal ?" {
            performSegue(withIdentifier: "toFinishGoalVC", sender: self)
        }
    }
    
    @IBAction func unwindSegueAction(unwindSegueAction: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let finishGoalSegue = segue.destination as? FinishGoalVC
        else {
            return
        }
        
        finishGoalSegue.goalDescription = self.createGoalTV.text
        finishGoalSegue.goalType = self.goalType
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.createGoalTV.text = ""
        self.createGoalTV.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}
