//
//  API.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import Foundation

class API {
    class func addItem(name : String , description : String, price:String ,completion: @escaping(_ error: Error?, _ status: Bool)-> Void) {
        let bodyData = "name=\(name)&description=\(description)&price=\(price)"
        guard let url = URL(string: URLs.add) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data,response,error)in
            do {
                guard let data = data else {return}
                
                let response = try JSONDecoder().decode(itemsOpitions.self, from: data)
                if response.status == "true" {
                    
                    completion(nil,true)
                }
                else {
                    completion(nil,false)
                }
                
            }
            catch {
                completion(error,false)
            }
            }.resume()
    }
    
    class func showItem (completion: @escaping(_ error: Error?, _ status: Bool,_ showArray: [Data]?)-> Void) {
        let show = "true"
        let bodyData = "show=\(show)"
        var showArrayData = [Data]()
        guard let url = URL(string: URLs.show) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data,response,error)in
            do {
                guard let data = data else {return}
                
                let datashow = try JSONDecoder().decode(Response.self, from: data)
                if datashow.status == "true" {
                    showArrayData = datashow.message!
                    completion(nil,true,showArrayData)
                }
                else {
                    completion(nil,false,nil)
                }
                
            }
            catch {
                completion(error,false,nil)
            }
            }.resume()
    }
    
    
    
    
    class func deleteItem(id: String,completion : @escaping(_ error: Error? ,_ status: Bool)->Void){
        let bodyData = "id=\(id)"
        guard let url = URL(string: URLs.delete) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        session.dataTask(with: request){(data,response,error)in
            do {
                guard let data = data else {return}
                let Delete = try JSONDecoder().decode(itemsOpitions.self, from: data)
                if Delete.status == "true" {
                    
                    completion(nil,true)
                }
                else {
                    completion(nil,false)
                }
            }
            catch
            {
                completion(error,false)
            }
            }.resume()
    }
    
    class func editedItem(name: String, description: String,price: String, id: String,completion: @escaping(_ error: Error?, _ status: Bool)-> Void) {
        
        let bodyData = "name=\(name)&description=\(description)&price=\(price)&id=\(id)"
        guard let url = URL(string: URLs.edit) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            guard let data = data else {return}
            do {
                let editedItem = try JSONDecoder().decode(itemsOpitions.self, from: data)
                if editedItem.status == "true" {
                    print(editedItem.message!)
                    completion(nil,true)
                }
                else {
                    completion(nil,false)
                }
            }
            catch {
                completion(error,false)
            }
            }.resume()
    }
    
    
    
    
    
    
}

