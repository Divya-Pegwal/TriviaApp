//
//  ViewController.swift
//  Trivia App
//


import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:-IBOutles
    @IBOutlet weak var nameTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        nameTF.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    //MARK:-Next Btn Action
    @IBAction func NextBtnAction(_ sender: Any) {
        _ = UIStoryboard(name: "Main", bundle: nil)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "CricketerViewController") as! CricketerViewController
        var name = nameTF.text
        UserDefaults.standard.set(name, forKey: "UserName")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

