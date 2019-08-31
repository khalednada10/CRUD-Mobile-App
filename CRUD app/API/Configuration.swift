//
//  Configuration.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import Foundation
struct URLs {
    
    static let baseURL = "http://azura-re.com/productsapi/"
    
    //    post {name,description,price}
    static let add = baseURL + "add.php"
    
    //    post {show}
    static let show = baseURL + "show.php"
    
    //    post {id}
    static let delete = baseURL + "delete.php"
    
    //    post {id,name,description,price}
    static let edit = baseURL + "edit.php"
    
    
}
