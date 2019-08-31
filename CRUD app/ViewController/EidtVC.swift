//
//  EidtVC.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import UIKit
import SwiftMessages
import CoreData


class EidtVC: UIViewController {
    let reachability = Reachability()
    var name : String?
    var itemDescription : String?
    var price : String?
    var id : String?
    var editState = false
    var product = [Product]()
    
    @IBOutlet weak var eidtTitleTextFiled: UITextField!
    @IBOutlet weak var eidtDescriptionTextFiled: UITextView!
    @IBOutlet weak var eidetPriceTextFiled: UITextField!
    @IBOutlet weak var editButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eidtTitleTextFiled.text = name
        eidtDescriptionTextFiled.text = itemDescription
        eidetPriceTextFiled.text = price
        viewUpdate(flag: editState)
        
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
    func handleReachability() {
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: reachability, queue: .main) { (notification) in
            if let MyRechability = notification.object as? Reachability {
                switch MyRechability.connection {
                case .cellular:
                    self.displayMessage(message: "Connected by cellular data", messageError: false)
                    self.product = self.getProductData()
                    if self.product.isEmpty == false{
                        for item in self.product{
                            API.editedItem(name: item.title!, description: item.descrebtion!, price: item.price!,id:self.id!, completion: { (erroe, status) in
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
                            API.editedItem(name: item.title!, description: item.descrebtion!, price: item.price!,id:self.id!, completion: { (erroe, status) in
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
        product.setValue(eidtTitleTextFiled.text!, forKey: "title")
        product.setValue(eidtDescriptionTextFiled.text!, forKey: "descrebtion")
        product.setValue(eidetPriceTextFiled.text!, forKey: "price")
        do{
            try context.save()
            let alertActionController = UIAlertController(title: "Saved", message: "Your Proudct Update Saved in Locaol Storage", preferredStyle: .alert)
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
    
    @IBAction func eidtItemPressed(_ sender: Any) {
        if Helper.checkConnection() {
            if editState == false{
                editState = true
                viewUpdate(flag: editState)
            }else {
                editState = false
                viewUpdate(flag: editState)
                guard let title = eidtTitleTextFiled.text, !title.isEmpty else {return}
                guard let description = eidtDescriptionTextFiled.text, !description.isEmpty else {return}
                guard let price = eidetPriceTextFiled.text, !price.isEmpty else {return}
                API.editedItem(name: title, description: description, price: price, id: id!){ (error, status) in
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }else{
            if editState == false{
                editState = true
                viewUpdate(flag: editState)
            }else {
                editState = false
                viewUpdate(flag: editState)
                saveDatatoCoreData()
            }
        }
        
    }
    func viewUpdate(flag : Bool) {
        if flag{
            eidtTitleTextFiled.isUserInteractionEnabled = true
            eidtTitleTextFiled.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            eidtDescriptionTextFiled.isUserInteractionEnabled = true
            eidtDescriptionTextFiled.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            eidetPriceTextFiled.isUserInteractionEnabled = true
            eidetPriceTextFiled.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            editButton.setTitle("Save", for: .normal)
        }else{
            eidtTitleTextFiled.isUserInteractionEnabled = false
            eidtTitleTextFiled.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            eidtDescriptionTextFiled.isUserInteractionEnabled = false
            eidtDescriptionTextFiled.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            eidetPriceTextFiled.isUserInteractionEnabled = false
            eidetPriceTextFiled.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            editButton.setTitle("Edit", for: .normal)
            
        }
        
        
        
    }
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DataShowVC = storyBoard.instantiateViewController(withIdentifier: "show") as! DataShowVC
        self.present(DataShowVC,animated: true ,completion: nil)
    }
    
    
    func getCoreDataObject ()  -> NSManagedObjectContext{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let coreDataObject = appDelegate.persistentContainer.viewContext
        
        return coreDataObject
        
    }
    
    
    
}
