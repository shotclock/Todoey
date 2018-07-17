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

    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
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

}

