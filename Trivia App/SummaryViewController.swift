//
//  SummaryViewController.swift
//  Trivia App
//


import UIKit
import CoreData

class SummaryViewController: UIViewController {
    
    //MARK:-IBOutles
    @IBOutlet weak var bestCricketerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagColorLabel: UILabel!
    
    //MARK:-Variables
    var peoples: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate =  NSDate()
        print(currentDate)
        var userName = UserDefaults.standard.value(forKey: "UserName")
        var crickName = UserDefaults.standard.value(forKey: "CricketerName")
        var flagColor = UserDefaults.standard.value(forKey: "ColorArray")
        save(name: userName as! String,date: currentDate,cricketerName: crickName as! String,flag: flagColor as! [String])
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FetchCoreData()
    }
    
    //MARK:- Fetch core data
    func FetchCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            peoples = try managedContext.fetch(fetchRequest)
            for people in peoples {
                if let name = people.value(forKey: "name") as? String {
                    nameLabel.text = "Hello:  " + name
                }
                if let favCri = people.value(forKey: "favCricketer") as? String {
                    bestCricketerLabel.text = "Answer: " + "\(favCri)"
                }
                if let favColorData = people.value(forKey: "flagColor") as? NSData {
                    let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: favColorData as Data)
                    print(arrayBack)
                    if arrayBack.count != 0 {
                        if arrayBack.count > 1 {
                            let stringRepresentation = arrayBack.joined(separator:",")
                            print(stringRepresentation)
                            flagColorLabel.text = "Answer: " + stringRepresentation
                        }else{
                            flagColorLabel.text = "Answer: \(arrayBack[0])"
                        }
                    }else {
                        flagColorLabel.text = "Answer:"
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK:-SAve to Core data
    func save(name: String,date: NSDate,cricketerName: String,flag: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        let arrayAsString: String = flag.description
        let stringAsData = arrayAsString.data(using: String.Encoding.utf16)
        print(stringAsData)
        person.setValue(stringAsData, forKeyPath: "flagColor")
        person.setValue(name, forKeyPath: "name")
        person.setValue(date, forKeyPath: "date")
        person.setValue(cricketerName, forKeyPath: "favCricketer")
        do {
            try managedContext.save()
            peoples.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK:-history Btn Action
    @IBAction func HistoryBtnAction(_ sender: Any) {
        _ = UIStoryboard(name: "Main", bundle: nil)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    //MARK:-Finish Btn Action
    @IBAction func FinishBtnAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "UserName")
        UserDefaults.standard.removeObject(forKey: "CricketerName")
        UserDefaults.standard.removeObject(forKey: "ColorArray")
        _ = UIStoryboard(name: "Main", bundle: nil)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
