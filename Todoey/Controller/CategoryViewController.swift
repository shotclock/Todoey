//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 이상호 on 2018. 7. 25..
//  Copyright © 2018년 이상호. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //오류를 낼 일이 거의 없는 코드에 대해서 간결함을 위해 ! 사용
    let realm = try! Realm()
    
    //result = 배열과 같은 realm의 쿼리 결과값
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "새 카테고리 추가", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "카테고리 추가", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "새 카테고리 이름을 입력하세요."
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //categoryArray가 nil이 아니면 count 반환, nil인 경우 1반환
        // -> nil coalescing operator
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "카테고리가 없습니다."
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //categoryArray가 nil이아닌경우만 실행
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategory(){
        //realm에 있는 모든 카테고리 오브젝트 아이템들을 꺼내온다.
        //save메소드에서 add를 통해 자동으로 update되므로 테이블 뷰에서 보인다.
        categoryArray = realm.objects(Category.self)
    }
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("카테고리를 저장하는 데 오류 발생 \(error)")
        }
        
        self.tableView.reloadData()
    }
    
}
