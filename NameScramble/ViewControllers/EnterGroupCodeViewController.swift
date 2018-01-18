//
//  EnterGroupCodeViewController.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/12/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import UIKit

class EnterGroupCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstCharTextField: UITextField!
    @IBOutlet weak var secondCharTextField: UITextField!
    @IBOutlet weak var thirdCharTextField: UITextField!
    @IBOutlet weak var fourthCharTextField: UITextField!
    @IBOutlet weak var fifthCharTextField: UITextField!
    @IBOutlet weak var sixthCharTextField: UITextField!
    @IBOutlet weak var seventhCharTextField: UITextField!
    @IBOutlet weak var eightCharTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstCharTextField.delegate = self;
        secondCharTextField.delegate = self;
        thirdCharTextField.delegate = self;
        fourthCharTextField.delegate = self;
        fifthCharTextField.delegate = self;
        sixthCharTextField.delegate = self;
        seventhCharTextField.delegate = self;
        eightCharTextField.delegate = self;
        
        firstCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        secondCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        thirdCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        fourthCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        fifthCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        sixthCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        seventhCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        eightCharTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let one = firstCharTextField.text,
            let two = secondCharTextField.text,
            let three = thirdCharTextField.text,
            let four = fourthCharTextField.text,
            let five = fifthCharTextField.text,
            let six = sixthCharTextField.text,
            let seven = seventhCharTextField.text,
            let eight = eightCharTextField.text else { return }
        
        let enteredCode = "\(one)\(two)\(three)\(four)\(five)\(six)\(seven)\(eight)"
        
        GroupController.shared.addUserToGroup(withCode: enteredCode) {
            print("Finished Completion Block")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.enterCodeViewToGroupUserViewSegue, sender: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        print("lskdjfsd")
    }

}
