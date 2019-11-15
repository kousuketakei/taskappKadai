//
//  ViewController.swift
//  taskappKadai
//
//  Created by 武井康祐 on 2019/11/02.
//  Copyright © 2019 KousukeTakei. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Realmインスタンスを取得する
    let realm = try! Realm()
    
    //DB内のタスクが格納されるリスト
    //日付近い順\順でソート：降順
    //以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try!Realm().objects(TaskKadai.self).sorted(byKeyPath: "date", ascending: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    // MARK: UITableViewDatasourceプロコトルのメソッド
    //データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //再利用なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //Cellに値を設定する。
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        let categoryLabel = cell.viewWithTag(1) as! UILabel
        categoryLabel.text = task.category
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm"
        
        let dateString: String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    //MARK: UITablerViewDelegateプロトコルのメソッド
    //各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    //セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    //Deleteボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        
    }
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
        let inputViewController:inputViewController = segue.destination as! inputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            
        } else {
            let task = TaskKadai()
            task.date = Date()
            
            let allTasks = realm.objects(TaskKadai.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1            }
            inputViewController.task = task
            
        }
        
    }
    //入力画面から戻ってきた時にTableViewを更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
}
