//
//  LogInViewController.swift
//  OpenTrivia
//
//  Created by Sailor on 13/08/2019.
//  Copyright © 2019 sailor.OpenTrivia. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    var countQuestion = ["5","10","15"]
    var count = 5 //default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknamePlayer2.delegate = self
        nicknamePlayer1.delegate = self
    }
    
    @IBOutlet weak var labelPlayer1: UILabel!
    @IBOutlet weak var nicknamePlayer1: UITextField!
    @IBOutlet weak var labelPlayer2: UILabel!
    @IBOutlet weak var nicknamePlayer2: UITextField!
    @IBOutlet weak var pickerViewOut: UIPickerView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMain" {
            let destination = segue.destination as! MainViewController
             guard let nick1 = nicknamePlayer1.text,!nick1.isEmpty,
                let nick2 = nicknamePlayer2.text,!nick2.isEmpty else {
                    let alertView = UIAlertController(title: "Error", message: "Ingrese valores", preferredStyle: .alert)
                    
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alertView, animated: true, completion: nil)
                   return
            }
            
            destination.nickname1Str = nick1
            destination.nickname2Str = nick2
            destination.individualCountQuestion = count
            destination.delegate = self
        }
    }

}

extension LogInViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nicknamePlayer1.resignFirstResponder()
        nicknamePlayer2.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

extension LogInViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countQuestion.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countQuestion[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.count = Int(countQuestion[row])!
    }
    
    
}
