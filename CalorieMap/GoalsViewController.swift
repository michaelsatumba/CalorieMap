//
//  GoalsViewController.swift
//  CalorieMap
//
//  Created by Jarrett Zapata on 5/2/22.
//

import UIKit

class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var goals = [GoalEntry]()
    
    @IBOutlet weak var goalsTable: UITableView!
    
    override func viewDidLoad() {
        title = "Goals"
        super.viewDidLoad()
        goalsTable.delegate = self
        goalsTable.dataSource = self
        getAllGoals()
        goalsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Goal", message: "Enter new goal", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createGoal(goalDescription: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goal = goals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = goal.goalDescription
        
        let goalCompleteSwitch = UISwitch()
        goalCompleteSwitch.tag = indexPath.row
        goalCompleteSwitch.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
        goalCompleteSwitch.isOn = goal.isComplete
        cell.accessoryView = goalCompleteSwitch
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            let alert = UIAlertController(title: "Edit Goal", message: "Edit Goal", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = goal.goalDescription
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newGoal = field.text, !newGoal.isEmpty else {
                    return
                }
                
                self?.updateGoalDescription(item: goal, newDescription: newGoal)
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self]_ in
            self?.deleteGoal(item: goal)
        }))
        present(sheet, animated: true)
    }
    
    @objc func didChangeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            updateGoalIsComplete(item: goals[sender.tag], isComplete: true)
            getAllGoals()
        } else {
            updateGoalIsComplete(item: goals[sender.tag], isComplete: false)
            getAllGoals()
        }
    }
    
    // MARK: - Core Data
    
    func getAllGoals() {
        do {
            goals = try context.fetch(GoalEntry.fetchRequest())
            DispatchQueue.main.async {
                self.goalsTable.reloadData()
            }
        } catch {
            // error
        }
    }
    
    func createGoal(goalDescription:String) {
        let newGoal = GoalEntry(context: context)
        newGoal.goalDescription = goalDescription
        
        do {
            try context.save()
            getAllGoals()
        } catch {
            
        }
    }
    
    func deleteGoal(item: GoalEntry) {
        context.delete(item)
        
        do {
            try context.save()
            getAllGoals()
        } catch {
            
        }
    }
    
    func updateGoalDescription(item: GoalEntry, newDescription: String) {
        item.goalDescription = newDescription
        
        do {
            try context.save()
            getAllGoals()
        } catch {
            
        }
    }
    
    func updateGoalIsComplete(item: GoalEntry, isComplete: Bool) {
        item.isComplete = isComplete
        
        do {
            try context.save()
            getAllGoals()
        } catch {
            
        }
    }

}

