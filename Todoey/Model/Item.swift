//
//  Item.swift
//  Todoey
//
//  Created by 이상호 on 2018. 7. 26..
//  Copyright © 2018년 이상호. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //ITEM > CATEGORY로 가는 relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
