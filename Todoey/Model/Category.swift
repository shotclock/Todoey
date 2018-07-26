//
//  Category.swift
//  Todoey
//
//  Created by 이상호 on 2018. 7. 26..
//  Copyright © 2018년 이상호. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    //realm에서 relationship을 만들 때 사용
    let items = List<Item>()
}
