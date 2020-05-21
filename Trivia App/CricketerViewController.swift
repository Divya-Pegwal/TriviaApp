//
//  CricketerViewController.swift
//  Trivia App
//


import UIKit

class CricketerViewController: UIViewController{
    
    //MARK:-IBOutles
    @IBOutlet weak var cricketerTableView: UITableView!
    
    //MARK:-Variables
    var dataArray = ["Sachin Tendulkar","Virat kohli", "Adam Gilchirst","Jacques Kallis"]
    var seqArr = ["A)","B)","C)","D)"]
    var checkedUncheckedArr = [0,0,0,0]
    var isSelected = false
    var previousRowNumIndex = Int()
    var cricketerName = String()
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.value(forKey: "UserName"))
        cricketerTableView.delegate = self
        cricketerTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK:-Next btn Action
    @IBAction func NextBtnAction(_ sender: Any) {
        UserDefaults.standard.set(cricketerName, forKey: "CricketerName")
        _ = UIStoryboard(name: "Main", bundle: nil)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "FlagColourViewController") as! FlagColourViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
//MARK:- cell class
class CricketerTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seqLable: UILabel!
}
// MARK:- Extension for TableView
extension CricketerViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(checkedUncheckedArr)
        let currentIndex = indexPath.row
        if currentIndex == previousRowNumIndex && isSelected {
            checkedUncheckedArr[indexPath.row] = 0
            isSelected = false
            cricketerName = ""
        }else {
            if checkedUncheckedArr.contains(1){
                checkedUncheckedArr = [0,0,0,0]
                isSelected = true
                checkedUncheckedArr[indexPath.row] = 1
                previousRowNumIndex = indexPath.row
                cricketerName = dataArray[indexPath.row]
            }else {
                if checkedUncheckedArr[indexPath.row] == 0{
                    isSelected = true
                    checkedUncheckedArr[indexPath.row] = 1
                    previousRowNumIndex = indexPath.row
                    cricketerName = dataArray[indexPath.row]
                }
                else {
                    checkedUncheckedArr[indexPath.row] = 0
                    isSelected = false
                    cricketerName = ""
                }
            }
        }
        print(checkedUncheckedArr)
        
        self.cricketerTableView.reloadData()
        print(cricketerName)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CricketerTableViewCell", for: indexPath) as! CricketerTableViewCell
        // cell.photoImageView.image = profileImages[indexPath.item]
        
        cell.nameLabel?.text =  (dataArray[indexPath.row])
        cell.seqLable?.text =  (seqArr[indexPath.row])
        if checkedUncheckedArr[indexPath.row] == 0 {
            cell.nameLabel.textColor = UIColor.black
        }else {
            cell.nameLabel.textColor = UIColor.blue
        }
        return cell
    }
    
    
}
