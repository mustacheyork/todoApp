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
  
  // Eメールアドレス
  @IBOutlet weak var EmailField: UITextField!
  
  // パスワード
  @IBOutlet weak var PasswordField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // 入力された文字を非表示モードにする.
    PasswordField.isSecureTextEntry = true
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // ログインしていなければログイン画面を表示
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
  
  // Sigh Inボタンのタップ時の処理
  @IBAction func didTapSignIn(_ sender: Any) {
    // 入力されたデータを保持
    let email = EmailField.text
    let password = PasswordField.text
    
    // 認証処理
    Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
      // 認証できなければエラーを表示
      guard let _ = user else {
        if let error = error {
          if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .userNotFound:
              // Eメールアドレスがなかった場合
              self.showAlert("User account not found. Try registering")
            case .wrongPassword:
              // Eメールアドレスとパスワードの不一致の場合
              self.showAlert("Incorrect username/password combination")
            default:
              // 上記以外のエラー表示
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
  
  // Registerボタンのタップ時の処理
  @IBAction func didTapRegister(_ sender: Any) {
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
    dismiss(animated: true, completion: nil)
  }
  
}
