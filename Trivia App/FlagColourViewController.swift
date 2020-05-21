//
//  FlagColourViewController.swift
//  Trivia App
//


import UIKit


class FlagColourViewController: UIViewController {
    
    //MARK:-IBOutles
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var flagColorTableView: UITableView!
    
    //MARK:-Variables
    var dataArray = ["White","Yellow", "Orange","Green"]
    var seqArr = ["A)","B)","C)","D)"]
    var checkedUncheckedArr = [0,0,0,0]
    var isSelected = false
    var count = 0
    var colorArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flagColorTableView.delegate = self
        flagColorTableView.dataSource = self
    }
    
    //MARK:-Next Btn Action
    @IBAction func NextBtnAction(_ sender: Any) {
        UserDefaults.standard.set(colorArray, forKey: "ColorArray")
        _ = UIStoryboard(name: "Main", bundle: nil)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:-Select All Btn Action
    @IBAction func SelectAllBtnAction(_ sender: Any) {
        if count == dataArray.count{
            isSelected = false
            count = 0
            checkedUncheckedArr = [0,0,0,0]
            colorArray = [""]
        }
        else {
            isSelected = true
            count = dataArray.count
            checkedUncheckedArr = [1,1,1,1]
            colorArray = dataArray
        }
        print(colorArray)
        self.flagColorTableView.reloadData()
    }
    
}
//MARK:- cell class
class FlagColourTableViewCell: UITableViewCell {
    @IBOutlet weak var sequesNameLabel: UILabel!
    @IBOutlet weak var colorNameLabel: UILabel!
}
// MARK:- Extension for TableView
extension FlagColourViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkedUncheckedArr[indexPath.row] == 0 {
            isSelected = true
            checkedUncheckedArr[indexPath.row] = 1
            count+=1
            let color = dataArray[indexPath.row]
            colorArray.append(color)
        }
        else {
            checkedUncheckedArr[indexPath.row] = 0
            count-=1
            let row = indexPath.row
            colorArray.remove(at: row)
        }
//        if count == dataArray.count {
//            //selectAllBtn.isHighlighted = true
//        }
//        else {
//            // selectAllBtn.isHighlighted = false
//        }
        self.flagColorTableView.reloadData()
        print(colorArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagColourTableViewCell", for: indexPath) as! FlagColourTableViewCell
        // cell.photoImageView.image = profileImages[indexPath.item]
        
        cell.colorNameLabel?.text =  (dataArray[indexPath.row])
        cell.sequesNameLabel?.text =  (seqArr[indexPath.row])
        if checkedUncheckedArr[indexPath.row] == 0 {
            cell.colorNameLabel.textColor = UIColor.black
        }
        else {
            cell.colorNameLabel.textColor = UIColor.blue
        }
        return cell
    }
    
    
}
