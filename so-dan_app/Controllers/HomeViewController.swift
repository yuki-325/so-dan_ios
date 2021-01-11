//
//  HomeViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/07.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var consultationTableView: UITableView!
    let  db = Firestore.firestore() //DBの参照
    var consultations: [Consultation] = [] //相談情報格納用の配列
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consultationTableView.dataSource = self
        consultationTableView.delegate = self
        consultationTableView.register(UINib(nibName: Constants.consultationCell, bundle: nil), forCellReuseIdentifier: Constants.consultationCell)
        loadData()
    }
    
    func loadData() {
        db.collection(Constants.FStore.consultationsCollection)
            .order(by: Constants.FStore.createdAtField, descending: true) //送信した順にソート 昇順
            .addSnapshotListener { (querySnapShot, error) in //相談が追加されるたびに
                self.consultations = []
                if let _error = error {
                    print("データの読み込みに失敗しました:\(_error.localizedDescription)")
                } else {
                    if let snapShotDocuments = querySnapShot?.documents {
                        
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            
                            //consultationsの中から自分が送受信した内容のみ配列に追加する
                            if data[Constants.FStore.senderEmailField] as? String == Auth.auth().currentUser?.email ||
                                data[Constants.FStore.receiverEmailField] as? String == Auth.auth().currentUser?.email {
                                let newConsultation = Consultation(dic: data)
                                self.consultations.append(newConsultation)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.consultationTableView.reloadData() //tableViewをリロード
                        }
                    }
                }
            }
    }
    
    func consultationDelete(title: String, senderEmail: String, receiverEmail: String, indexNumber: Int) {
        let currentUserEmail = Auth.auth().currentUser?.email
        
        //引数で受け取ったtitleで検索をし該当のドキュメントを取得
        db.collection(Constants.FStore.consultationsCollection).whereField(Constants.FStore.titleField, isEqualTo: title).getDocuments { (snapShot, error) in
            if let _error = error {
                print(_error.localizedDescription)
                AlertAction.alert(title: "エラー", message: "データの取得に失敗しました。", viewController: self)
                
                return
            }
            
            for doc in snapShot!.documents {
                let data = doc.data()
            
                //送信者が自分の相談 || 受信者が自分の相談のみdocIDListへ格納
                if currentUserEmail == data[Constants.FStore.senderEmailField] as? String ||
                    currentUserEmail == data[Constants.FStore.receiverEmailField] as? String {
                    
                    //データ削除
                    self.dataDelete(docId: doc.documentID)
                }
            }
        }
    }
    
    func dataDelete(docId: String) {
        db.collection(Constants.FStore.consultationsCollection).document(docId).delete { (error) in
            if let _error = error {
                print(_error.localizedDescription)
                AlertAction.alert(title: "エラー", message: "データの削除に失敗しました。", viewController: self)
                return
            }
        }
    }
}




//MARK: - UITableViewDataSource UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consultations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let consultation = consultations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.consultationCell, for: indexPath) as! ConsultationCell
        cell.titleLabel.text = consultation.title
        cell.contentLabel.text = consultation.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //cellの高さ指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //cellを右から左へスワイプした時の処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "削除",
                                              handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                //本当に削除していいかの確認
                                                AlertAction.alert(title: "", message: "本当に削除してもよろしいですか？", viewController: self) { (confirmed) in
                                                    if confirmed {
                                                        //DBで該当するデータを削除
                                                        let title = self.consultations[indexPath.row].title
                                                        let senderEmail = self.consultations[indexPath.row].senderEmail
                                                        let receiberEmail = self.consultations[indexPath.row].receiverEmail
                                                        
                                                        self.consultationDelete(title: title, senderEmail: senderEmail, receiverEmail: receiberEmail, indexNumber: indexPath.row)
                                                    
                                                        DispatchQueue.main.async {
                                                            self.consultationTableView.reloadData() //tableViewをリロード
                                                        }
                                                    } else {
                                                        //何もしない
                                                    }
                                                }
                                        
                                                completion(true)
                                                
                                              })
        deleteAction.backgroundColor = UIColor.rgba(red: 214, green: 69, blue: 65, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
