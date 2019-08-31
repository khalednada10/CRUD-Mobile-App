//
//  ShowdataTableViewController.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import UIKit
import SwiftMessages
import CoreData

class DataShowVC: UIViewController {
    let reachability = Reachability()
    @IBOutlet var dataShowTableView: UITableView!
    var showData = [Data]()
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try reachability?.startNotifier()
        } catch let error {
            print(error)
        }
        
        
        handleReachability()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.dataShowTableView.addSubview(self.refressher)
            self.handleRefresh()
        }
        super.viewWillAppear(animated)
        
    }
    
    func handleReachability() {
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: reachability, queue: .main) { (notification) in
            if let MyRechability = notification.object as? Reachability {
                switch MyRechability.connection {
                case .cellular:
                    self.displayMessage(message: "Connected by cellular data", messageError: false)
                case .wifi:
                    self.displayMessage(message: "Connected by Wifi", messageError: false)
                case .none:
                    self.displayMessage(message: "No Internet Connection", messageError: true)
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    func displayMessage(message: String, messageError: Bool) {
        
        let view = MessageView.viewFromNib(layout: MessageView.Layout.messageView)
        if messageError == true {
            view.configureTheme(.error)
        } else {
            view.configureTheme(.success)
        }
        
        view.iconImageView?.isHidden = true
        view.iconLabel?.isHidden = true
        view.titleLabel?.isHidden = true
        view.bodyLabel?.text = message
        view.titleLabel?.textColor = UIColor.white
        view.bodyLabel?.textColor = UIColor.white
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        SwiftMessages.show(config: config, view: view)
    }
    
    lazy var refressher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
    }()
    
    @objc private func handleRefresh(){
        API.showItem { (error: Error?, status: Bool, Array: [Data]?) in
            self.showData = Array!
            DispatchQueue.main.async {
                self.dataShowTableView.reloadData()
                self.refressher.endRefreshing()
            }
        }
        
        
    }
    
    @IBAction func AddbuttomAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AddItemVC = storyBoard.instantiateViewController(withIdentifier: "Add") as! AddItemVC
        self.present(AddItemVC,animated: true ,completion: nil)
    }
}


extension DataShowVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "externalCell", for: indexPath) as! externalTableViewCell
        cell.titleLabel.text = showData[indexPath.row].name!
        cell.descripitionLabel.text = showData[indexPath.row].description!
        cell.priceLabel.text = showData[indexPath.row].price!
        return cell
    }
}

extension DataShowVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemDetails = storyBoard.instantiateViewController(withIdentifier: "edit") as! EidtVC
        itemDetails.name = showData[indexPath.row].name!
        itemDetails.itemDescription = showData[indexPath.row].description!
        itemDetails.price = showData[indexPath.row].price!
        itemDetails.id = showData[indexPath.row].id!
        
        self.present(itemDetails,animated: true ,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Array = showData [indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, IndexPath) in
            API.deleteItem(id: Array.id!, completion: { (error, status) in
                
            })
            
            self.deleteAction( Array:Array , indexPath:IndexPath)
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
    private func deleteAction( Array: Data , indexPath:IndexPath) {
        let alert = UIAlertController (title: "Delete", message:"Are you sure you want to Delete this Product ?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.showData.remove(at:indexPath.row)
            self.dataShowTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present (alert, animated: true)
        
    }
}




