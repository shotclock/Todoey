//
//  Item.swift
//  Todoey
//
//  Created by 이상호 on 2018. 7. 23..
//  Copyright © 2018년 이상호. All rights reserved.
//

import Foundation


//encodable : json이나 plist로 encode 가능
//인코드및 디코드 하기 위해서 모든 속성의 타입이 기본 타입이어야 한다. --> 커스텀 타입 사용 불가
class Item : Codable{
    var title : String = ""
    var done : Bool = false
}
