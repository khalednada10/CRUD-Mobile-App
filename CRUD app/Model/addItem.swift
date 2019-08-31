//
//  addItem.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import Foundation

struct itemsOpitions: Decodable {
    let status: String?
    let message :String?
}


struct defaults: Decodable {
    let status: Bool?
    
}
