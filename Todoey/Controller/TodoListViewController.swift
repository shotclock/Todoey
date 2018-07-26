//
//  ViewController.swift
//  Todoey
//
//  Created by 이상호 on 2018. 7. 17..
//  Copyright © 2018년 이상호. All rights reserved.
//

import UIKit
import CoreData

//uitableviewcontroller를 상속하면 대리자 등을 지정해줄 필요가 없다.
class TodoListViewController : UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            //selectedCategory가 값을 가지게 된 경우에 괄호 안의 내용이 수행된다.
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        saveItem()
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItem()
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
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("컨텍스트를 저장하는데 에러 발생 \(error)")
        }
        self.tableView.reloadData()
    }
    
    //괄호 밖에서 쓰이는 파라미터의 이름 : with
    //괄호 안에서 쓰이는 파라미터의 이름 : request
    // = default 값
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("데이터를 불러오는데 실패했습니다. \(error)")
        }
        tableView.reloadData()
    }
    
    
}

//MARK: - SearchBar Method
//똑같은 클래스에 대해서 여러 기능을 나누어 코딩하는데 쓰는 예약어 --> 모듈화
extension TodoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //%@ --> argument에 오는 파라미터로 대치 가능한 문법
        //[cd] --> 대소문자 구별과 독일어, 프랑스어에 있는 기호들을 무시한다.
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //sortDescriptors는 배열 형태를 가지고 있다.
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
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
