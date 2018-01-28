//
//  ViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 26..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class SignViewController: UIViewController {
    //MARK -: Properties
    @IBOutlet weak var textField: UITextField!
    
    
    //MARK -: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage()
        self.textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UserDefaults.standard.set(textField.text, forKey: "id")
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TabBarViewController.reuseIdentifier)
        self.present(nextVC, animated: true, completion: nil)
        textField.text = nil
        return true
    }
}
