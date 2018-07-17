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

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - Tableview Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //cellforrow : 인덱스 패스에 해당되는 셀을 반환하는 메소드
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //셀을 선택하면 선택한 셀이 지속적으로 표시되어 있는 것에서 깜빡이는 효과로 바뀌게 된다.
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "새로운 할 일 추가", message: "", preferredStyle:.alert)
        //uialert에 생길 버튼
        let action = UIAlertAction(title: "할 일 추가", style: .default) { (action) in
            //버튼이 눌릴 경우 실행할 코드
            
            self.itemArray.append(textField.text!)
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

