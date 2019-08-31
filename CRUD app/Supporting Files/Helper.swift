//
//  Helper.swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class Helper {
    
    class func checkConnection () -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
    
    class func showAlert(title: String, message: String,viewController: UIViewController) -> Void
    {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default,handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
