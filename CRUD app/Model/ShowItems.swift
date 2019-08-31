//
//  ShowItems.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import Foundation
struct Response : Decodable {
    let status: String?
    let message: [Data]?
    
}
struct Data : Decodable {
    let id : String?
    let name: String?
    let description : String?
    let price : String?
}
