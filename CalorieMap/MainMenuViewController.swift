

import UIKit

class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewSelectorTable: UITableView!
    
    var viewSelectionSegueIdentifiers:[String] = ["Calorie Map","User Profile", "Goals","Steps", "Calories Burned"];
    
    override func viewDidLoad() {
        title = "Calorie Tracker"
        viewSelectorTable.delegate = self
        viewSelectorTable.dataSource = self
        viewSelectorTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewSelectionSegueIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewSelectionSegueIdentifier = viewSelectionSegueIdentifiers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewSelectionSegueIdentifier
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewSelectionSegueIdentifier = viewSelectionSegueIdentifiers[indexPath.row]
        
        switch viewSelectionSegueIdentifier {
        case "Calorie Map":
            performSegue(withIdentifier: "calorieMapViewSegue", sender: indexPath)
        case "User Profile":
            performSegue(withIdentifier: "userProfileSegue", sender: indexPath)
        case "Goals":
            performSegue(withIdentifier: "goalsViewSegue", sender: indexPath)
        case "Steps":
            performSegue(withIdentifier: "stepsSegue", sender: indexPath)
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        return
    }

}

