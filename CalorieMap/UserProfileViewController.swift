//
//  UserProfileViewController.swift
//  CalorieMap
//
//  Created by Jarrett Zapata on 5/9/22.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var userProfile = [UserProfile]()
    
    @IBOutlet weak var userProfileTable: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Profile"
        userProfileTable.delegate = self
        userProfileTable.dataSource = self
        getUserProfile()
        userProfileTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Set up user profile", message: "Enter your information", preferredStyle: .alert)
        alert.addTextField { (userName) in
            userName.text = ""
            userName.placeholder = "Name"
        }
        alert.addTextField { (age) in
            age.text = ""
            age.placeholder = "Age (Enter numbers only)"
        }
        alert.addTextField { (weight) in
            weight.text = ""
            weight.placeholder = "Weight (Enter number of lbs)"
        }
        alert.addTextField { (height) in
            height.text = ""
            height.placeholder = "Height (Enter number of inches)"
        }
        alert.addTextField { (gender) in
            gender.text = ""
            gender.placeholder = "Gender (Male or Female)"
        }
            
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            let userNameField = alert.textFields![0]
            let ageField = alert.textFields![1]
            let weightField = alert.textFields![2]
            let heightField = alert.textFields![3]
            let genderField = alert.textFields![4]

            let userName = userNameField.text!
            let age = ageField.text!
            let weight = weightField.text!
            let height = heightField.text!
            let gender = genderField.text!
            
            self?.createUserProfile(userName: userName, age: Int16(age)!, weight: Int16(weight)!, height: Int16(height)!, gender: gender)
        }))
        present(alert, animated: true)
    }
    
    func getUserProfile() {
        do {
            userProfile = try context.fetch(UserProfile.fetchRequest())
            DispatchQueue.main.async {
                self.userProfileTable.reloadData()
            }
        } catch {
            // error
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func createUserProfile(userName:String, age:Int16, weight:Int16, height:Int16, gender:String) {
//        let newGoal = GoalEntry(context: context)
//        newGoal.goalDescription = goalDescription
        let newUserProfile = UserProfile(context: context)
        newUserProfile.name = userName
        newUserProfile.age = age
        newUserProfile.weight = weight
        newUserProfile.height = height
        newUserProfile.gender = gender
        
        do {
            try context.save()
            getUserProfile()
        } catch {
            
        }
    }
    
//    func updateGoalDescription(item: GoalEntry, newDescription: String) {
//        item.goalDescription = newDescription
//
//        do {
//            try context.save()
//            getAllGoals()
//        } catch {
//
//        }
//    }

    
}
