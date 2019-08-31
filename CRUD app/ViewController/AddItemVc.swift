//
//  AddItemViewController.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import UIKit
import SwiftMessages
import CoreData


class AddItemVC: UIViewController {
    let reachability = Reachability()
    var productMO = [NSManagedObject]()
    var product = [Product]()
    
    @IBOutlet weak var titleTextFiled: UITextField!
    @IBOutlet weak var descriptionTextFiled: UITextView!
    @IBOutlet weak var priceTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try reachability?.startNotifier()
        } catch let error {
            print(error)
        }
        handleReachability()
        
    }
    fileprivate func handleReachability() {
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: reachability, queue: .main) { (notification) in
            if let MyRechability = notification.object as? Reachability {
                switch MyRechability.connection {
                case .cellular:
                    self.displayMessage(message: "Connected by cellular data", messageError: false)
                    self.product = self.getProductData()
                    if self.product.isEmpty == false{
                        for item in self.product{
                            API.addItem(name: item.title!, description: item.descrebtion!, price: item.price!, completion: { (erroe, status) in
                                if status{
                                    self.deleteProduct()
                                    print("done")
                                }
                            })
                        }
                    }
                    
                case .wifi:
                    self.displayMessage(message: "Connected by Wifi", messageError: false)
                    self.product = self.getProductData()
                    if self.product.isEmpty == false{
                        for item in self.product{
                            API.addItem(name: item.title!, description: item.descrebtion!, price: item.price!, completion: { (erroe, status) in
                                if status{
                                    self.deleteProduct()
                                    print("done")
                                }
                            })
                        }
                    }
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
    
    func saveDatatoCoreData() {
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: context)
        let product = NSManagedObject(entity: entity!, insertInto: context)
        product.setValue(titleTextFiled.text!, forKey: "title")
        product.setValue(descriptionTextFiled.text!, forKey: "descrebtion")
        product.setValue(priceTextFiled.text!, forKey: "price")
        do{
            try context.save()
            let alertActionController = UIAlertController(title: "Saved", message: "Your Proudct Saved in Locaol Storage", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertActionController.addAction(alertAction)
            self.present(alertActionController, animated: true,completion: nil)
        } catch {
            
            let alertActionController = UIAlertController(title: "Error", message: "Can't Save", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertActionController.addAction(alertAction)
            self.present(alertActionController, animated: true,completion: nil)
        }
        
    }
    func deleteProduct(){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        if Helper.checkConnection() {
            guard let title = titleTextFiled.text, !title.isEmpty else {Helper.showAlert(title: "Missing data", message: "Please make sure that you fill Title", viewController: self)
                return
            }
            guard let description = descriptionTextFiled.text, !description.isEmpty else {Helper.showAlert(title: "Missing data", message: "Please make sure that you fill Description", viewController: self)
                return
            }
            guard let price = priceTextFiled.text, !price.isEmpty else {Helper.showAlert(title: "Missing data", message: "Please make sure that you fill Price", viewController: self)
                return
            }
            API.addItem(name: title  , description: description  , price: price ) {(error, status) in
                if status {
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                }
            }
            
        }else {
            saveDatatoCoreData()
            
        }
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DataShowVC = storyBoard.instantiateViewController(withIdentifier: "show") as! DataShowVC
        self.present(DataShowVC,animated: true ,completion: nil)
    }
    
    
    func getProductData () -> [Product] {
        
        let context = getCoreDataObject()
        
        var productArray = [Product]()
        
        do{
            productArray =  try context.fetch(Product.fetchRequest())
        }catch {
            
            print(error)
            
        }
        
        return productArray
    }
    
    func getCoreDataObject ()  -> NSManagedObjectContext{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let coreDataObject = appDelegate.persistentContainer.viewContext
        
        return coreDataObject
        
    }
    
    
}


