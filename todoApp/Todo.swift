//
//  Todo.swift
//  todoApp
//
//  Created by Swift-Beginners. on 2017/07/08.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Todo {
  var ref: DatabaseReference?
  var title: String?
  
  init (snapshot: DataSnapshot) {
    ref = snapshot.ref
    
    let data = snapshot.value as! Dictionary<String, String>
    title = data["title"]! as String
  }
}
