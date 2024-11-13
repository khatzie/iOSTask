//
//  NetworkManagers.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/13/24.
//

import Foundation

class NetworkManager {
    
    class func fetchData(urlString:String, completion:() -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url:url)) { data, response, error in
            if let data {
                
            } else {
                
            }
            
        }
    }
}
