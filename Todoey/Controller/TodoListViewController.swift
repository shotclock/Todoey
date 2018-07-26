//
//  ViewController.swift
//  Todoey
//
//  Created by 이상호 on 2018. 7. 17..
//  Copyright © 2018년 이상호. All rights reserved.
//

import UIKit
import RealmSwift

//uitableviewcontroller를 상속하면 대리자 등을 지정해줄 필요가 없다.
class TodoListViewController : UITableViewController {

    var todoItems :Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            //selectedCategory가 값을 가지게 된 경우에 괄호 안의 내용이 수행된다.
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //ternary operator
            //조건이 맞으면 왼쪽 아니면 오른쪽
            cell.accessoryType = item.done ? .checkmark : .none
        } else{
            cell.textLabel?.text = "해야할 일이 없습니다."
        }
        return cell
    }
    
    //MARK - Tableview Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch
            {
                print("완료 항목을 저장하는 데 오류 발생 \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "새로운 할 일 추가", message: "", preferredStyle:.alert)
        //uialert에 생길 버튼
        let action = UIAlertAction(title: "할 일 추가", style: .default) { (action) in
            //버튼이 눌릴 경우 실행할 코드
            
            //selectedCategory가 nil이 아닌경우
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("아이템을 저장하는데 실패 \(error)")
                }
            }
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
    
    //MARK - Model Manipulation Method

    func loadItems() {
        //selectedCategory에 연결되어있는 모든 item들을 title에 맞게 정렬한다.
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    
}

//MARK: - SearchBar Method
//똑같은 클래스에 대해서 여러 기능을 나누어 코딩하는데 쓰는 예약어 --> 모듈화
extension TodoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //%@ --> argument에 오는 파라미터로 대치 가능한 문법
        //[cd] --> 대소문자 구별과 독일어, 프랑스어에 있는 기호들을 무시한다.
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadItems()
            //assign work to diffrent thread
            //main 큐에게 아래의 동작을 하도록 지시 --> 시간이 걸릴 수도 있는 작업을 비동기 작업으로 수행
            DispatchQueue.main.async {
                //현재 선택된 상태가 아니게 만듬 --> 커서 x
                searchBar.resignFirstResponder()
            }


        }
    }
}
