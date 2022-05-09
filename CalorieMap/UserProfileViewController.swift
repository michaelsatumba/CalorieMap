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
        if (userProfile.isEmpty) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        } else {
            self.userNameLabel.text = userProfile[0].name
            self.setupLabelTap()
        }
        userProfileTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Edit Name", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = self.userProfile[0].name
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                return
            }
            
            self?.updateUserProfileName(newName: newName)
        }))
        self.present(alert, animated: true)
    }
        
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.userNameLabel.isUserInteractionEnabled = true
        self.userNameLabel.addGestureRecognizer(labelTap)
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (userProfile.isEmpty) {
            return cell
        } else {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Age: " + String(userProfile[0].age)
            case 1:
                cell.textLabel?.text = "Weight: " + String(userProfile[0].weight)
            case 2:
                cell.textLabel?.text = "Height: " + String(userProfile[0].height)
            case 3:
                cell.textLabel?.text = "Gender: " + userProfile[0].gender!
            default:
                print("Empty cell")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (userProfile.isEmpty != true) {
            switch indexPath.row {
            case 0:
                let alert = UIAlertController(title: "Edit Age", message: "Edit Age", preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                alert.textFields?.first?.text = String(self.userProfile[0].age)
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let field = alert.textFields?.first, let newAge = field.text, !newAge.isEmpty else {
                        return
                    }
                    
                    self?.updateUserProfileAge(newAge: Int16(newAge)!)
                }))
                self.present(alert, animated: true)
            case 1:
                let alert = UIAlertController(title: "Edit Weight", message: "Edit Weight", preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                alert.textFields?.first?.text = String(self.userProfile[0].weight)
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let field = alert.textFields?.first, let newWeight = field.text, !newWeight.isEmpty else {
                        return
                    }
                    
                    self?.updateUserProfileWeight(newWeight: Int16(newWeight)!)
                }))
                self.present(alert, animated: true)
            case 2:
                let alert = UIAlertController(title: "Edit Height", message: "Edit Height", preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                alert.textFields?.first?.text = String(self.userProfile[0].height)
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let field = alert.textFields?.first, let newHeight = field.text, !newHeight.isEmpty else {
                        return
                    }
                    
                    self?.updateUserProfileHeight(newHeight: Int16(newHeight)!)
                }))
                self.present(alert, animated: true)
            case 3:
                let alert = UIAlertController(title: "Edit Gender", message: "Edit Gender", preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                alert.textFields?.first?.text = self.userProfile[0].gender
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let field = alert.textFields?.first, let newGender = field.text, !newGender.isEmpty else {
                        return
                    }
                    
                    self?.updateUserProfileGender(newGender: newGender)
                }))
                self.present(alert, animated: true)
            default:
                print("Nothing to edit")
            }
        }
    }
    
    func createUserProfile(userName:String, age:Int16, weight:Int16, height:Int16, gender:String) {
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
    
    func updateUserProfileName(newName: String) {
        userProfile[0].name = newName
        
        do {
            try context.save()
            getUserProfile()
        } catch {

        }
    }
    
    func updateUserProfileAge(newAge: Int16) {
        userProfile[0].age = newAge
        
        do {
            try context.save()
            getUserProfile()
        } catch {

        }
    }
    
    func updateUserProfileWeight(newWeight: Int16) {
        userProfile[0].weight = newWeight
        
        do {
            try context.save()
            getUserProfile()
        } catch {

        }
    }
    
    func updateUserProfileHeight(newHeight: Int16) {
        userProfile[0].height = newHeight
        
        do {
            try context.save()
            getUserProfile()
        } catch {

        }
    }
    
    func updateUserProfileGender(newGender: String) {
        userProfile[0].gender = newGender
        
        do {
            try context.save()
            getUserProfile()
        } catch {

        }
    }

    
}
