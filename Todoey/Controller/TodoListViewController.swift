//
//  ViewController.swift
//  Todoey
//
//  Created by 이상호 on 2018. 7. 17..
//  Copyright © 2018년 이상호. All rights reserved.
//

import UIKit

//uitableviewcontroller를 상속하면 대리자 등을 지정해줄 필요가 없다.
class TodoListViewController : UITableViewController {

    var itemArray = [Item]()
    //유저디폴트는 싱글톤패턴 --> 1개의 인스턴스만 있다. --> 모든 클래스가 하나의 인스턴스를 사용
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        //데이터타입을 명확히 지정해주기위해서 cast해주어야 한다.
        if let item = defaults.array(forKey: "ToDoListArray") as? [Item]
        {
            itemArray = item
        }
    }

    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        //조건이 맞으면 왼쪽 아니면 오른쪽
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //cellforrow : 인덱스 패스에 해당되는 셀을 반환하는 메소드
        
        //셀을 선택하면 선택한 셀이 지속적으로 표시되어 있는 것에서 깜빡이는 효과로 바뀌게 된다.
        tableView.deselectRow(at: indexPath, animated: true)
        //체크마크표시 변경을 시각화하기 위함
        tableView.reloadData()
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "새로운 할 일 추가", message: "", preferredStyle:.alert)
        //uialert에 생길 버튼
        let action = UIAlertAction(title: "할 일 추가", style: .default) { (action) in
            //버튼이 눌릴 경우 실행할 코드
            
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //plist 파일에 저장되어 있다. -- 오브젝트 및 딕셔너리도 저장 및 불러오기가 가능하다
            // 유저 디폴트를 사용하면 (저장하던가 불러오던가) plist를 불러오게 되는데 이 plist의 크기가 크면 상당히 비효율적이된다. --> 유저디폴트는 데이터베이스가 아니다.
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            //유저가 누르기 전까지 텍스트 필드에 보일 회색 글자
            alertTextField.placeholder = "새 할 일을 입력하세요."
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

