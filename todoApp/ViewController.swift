//
//  ViewController.swift
//  todoApp
//
//  Created by Kanako Kobayashi on 2017/07/08.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource  {
  
  // Todoモデルのインスタンス生成
  var TodoLists = [Todo]()
  // Firebaseのインスタンス生成
  var ref: DatabaseReference!
  private var databaseHandle: DatabaseHandle!
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    FirebaseApp.configure()
    if Auth.auth().currentUser != nil {
      // User is signed in.
     
    } else {
      performSegue(withIdentifier: "goSignIn", sender: nil)
    }
    
    // Delegateの通知先を指定
    tableView.delegate = self
    // Datasourceの通知先を指定
    tableView.dataSource = self
    
    // Firebaseのインスタンスを作成
    ref = Database.database().reference()
    
    // Databaseの監視を開始
    startObservingDatabase()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // 追加をタップしてTodoを追加
  @IBAction func didTapAddTodo(_ sender: Any) {
    // Todoを入力するダイアログを生成
    let dialog = UIAlertController(title: "To Do App", message: "やること", preferredStyle: .alert)
    // OKボタンの生成
    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
      // 入力されたテキストを保持
      let userInput = dialog.textFields?.first?.text!
      // コンソールに出力
      print(userInput ?? "no data")
      if (userInput?.isEmpty)! {
        return
      }
      // Databaseにデータ更新
      self.ref.child("users").child("01").child("todolists").childByAutoId().child("title").setValue(userInput)
    }
    // ダイアログをリセット
    dialog.addTextField(configurationHandler: nil)
    // ダイアログにボタンを付与
    dialog.addAction(okAction)
    // ダイアログを表示
    present(dialog, animated: true, completion: nil);
  }
  
  // Cellの総数を返すdatasourceメソッド、設定必須
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TodoLists.count
  }
  
  // Cellに値を設定するdatasourceメソッド、設定必須
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Table View Cellを取得
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
    // Todoリストからデータを取得
    let todo = TodoLists[indexPath.row]
    // Cellにタイトルをセット
    cell.textLabel?.text = todo.title
    return cell
  }
  
  // Table Viewの更新を送信するdatasourceメソッド
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    // データが削除されたかチェック
    if editingStyle == .delete {
      // Todoリストからデータを取得
      let todo = TodoLists[indexPath.row]
      // Todoリストから削除
      todo.ref?.removeValue()
    }
  }
  
  // 監視をスタートさせるメソッド
  func startObservingDatabase () {
    // Databaseに変更があれば実行される
    databaseHandle = self.ref.child("users/01/todolists").observe(.value, with: { (snapshot) in
      // Todoリストのインスタンスを作成
      var newTodoLists = [Todo]()
      
      for todoSnapShot in snapshot.children {
        // 最新のデータを取得
        let todo = Todo(snapshot: todoSnapShot as! DataSnapshot)
        // 新しいTodoリストを作成
        newTodoLists.append(todo)
      }
      
      // TableViewに更新
      self.TodoLists = newTodoLists
      self.tableView.reloadData()
    })
  }
  
  @IBAction func didTapSignOut(_ sender: Any) {
    do {
      try Auth.auth().signOut()
      performSegue(withIdentifier: "goSignIn", sender: nil)
    } catch let error {
      assertionFailure("Error signing out: \(error)")
    }
  }
  
  
  // observeの終了処理
  deinit {
    self.ref.child("users/01/todolist").removeObserver(withHandle: databaseHandle)
  }
  
}

