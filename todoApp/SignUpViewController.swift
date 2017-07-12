//
//  SignUpViewController.swift
//  todoApp
//
//  Created by Kanako Kobayashi on 2017/07/12.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var EmailField: UITextField!
  
  @IBOutlet weak var PasswordField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBAction func didTapSignUp(_ sender: Any) {
    let email = EmailField.text
    let password = PasswordField.text
    Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
      if let error = error {
        if let errCode = AuthErrorCode(rawValue: error._code) {
          switch errCode {
          case .invalidEmail:
            self.showAlert("Enter a valid email.")
          case .emailAlreadyInUse:
            self.showAlert("Email already in use.")
          default:
            self.showAlert("Error: \(error.localizedDescription)")
          }
        }
        return
      }
      self.signIn()
    })
  }
  
  func showAlert(_ message: String) {
    let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func signIn() {
    performSegue(withIdentifier: "goTodoList", sender: nil)
  }
  
}
