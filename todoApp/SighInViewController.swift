//
//  SighInViewController.swift
//  todoApp
//
//  Created by Kanako Kobayashi on 2017/07/10.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import UIKit
import FirebaseAuth

class SighInViewController: UIViewController {
  
  
  @IBOutlet weak var EmailField: UITextField!
  
  @IBOutlet weak var PasswordField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let _ = Auth.auth().currentUser {
      self.signIn()
    }
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
  
  @IBAction func didTapSignIn(_ sender: Any) {
    let email = EmailField.text
    let password = PasswordField.text
    Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
      guard let _ = user else {
        if let error = error {
          if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .userNotFound:
              self.showAlert("User account not found. Try registering")
            case .wrongPassword:
              self.showAlert("Incorrect username/password combination")
            default:
              self.showAlert("Error: \(error.localizedDescription)")
            }
          }
          return
        }
        assertionFailure("user and error are nil")
        return
      }
      
      self.signIn()
    })
  }
  
  
  @IBAction func didTapRegister(_ sender: Any) {
        performSegue(withIdentifier: "goSignUp", sender: nil)
    
  }
  
  
  func showAlert(_ message: String) {
    let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func signIn() {
    dismiss(animated: true, completion: nil)
  }
  
}
