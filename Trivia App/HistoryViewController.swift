//
//  HistoryViewController.swift
//  Trivia App


import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    //MARK:-IBOutles
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK:-Variables
    var personData: [NSManagedObject] = []
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchCoreData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //MARK:-Fetch Core data
    func FetchCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            personData = try managedContext.fetch(fetchRequest)
            historyTableView.delegate = self
            historyTableView.dataSource = self
            historyTableView.reloadData()
            historyTableView.tableFooterView = UIView()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction func RestartBtnAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "UserName")
        UserDefaults.standard.removeObject(forKey: "CricketerName")
        UserDefaults.standard.removeObject(forKey: "ColorArray")
        _ = UIStoryboard(name: "Main", bundle: nil)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

//MARK:-Table Cell Class
class HistoryTableViewCell : UITableViewCell {
    @IBOutlet weak var gameNumlabl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var bestCrkLbl: UILabel!
    @IBOutlet weak var favColorLbl: UILabel!
}
// MARK:- Extension for TableView
extension HistoryViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let person = personData[indexPath.row]
        let val = indexPath.row
        cell.gameNumlabl.text = "GAME \(val+1) :"
        if let currDate = person.value(forKey: "date") as? NSDate {
            cell.dateLbl.text = Date().string(format: "d MMM yyyy h:mm a")
        }
        if let favCr = person.value(forKey: "favCricketer") as? String {
            cell.bestCrkLbl.text = "Answer: \(favCr)"
        }
        if let name = person.value(forKey: "name") as? String {
            cell.nameLbl.text = "Answer: \(name)"
        }
        if let favColorData = person.value(forKey: "flagColor") as? NSData {
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: favColorData as Data)
            print(arrayBack)
            let stringRepresentation = arrayBack.joined(separator:",")
            print(stringRepresentation)
            cell.favColorLbl.text = "Answer: " + stringRepresentation
        }
        return cell
    }
    
    
}
//MARK:- Get String from Date
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
