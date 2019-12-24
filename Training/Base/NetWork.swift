//
//  Service.swift
//  Training
//
//  Created by ManhLD on 12/10/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetWorkService {
    
    class var getInstance: NetWorkService {
         struct Static {
             static let instance: NetWorkService = NetWorkService()
         }
         return Static.instance
     }
    
    open func getRequestAPI(url: String, completionHandler: @escaping (JSON?, String) -> ()) {
        Alamofire.request(url , method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
                case .success(let value):
                completionHandler(JSON(value), "Success")
                case .failure( _):
                completionHandler(nil, "Failed")
            }
        }
    }
    
    
    open func postRequestAPI(url: String, params: [String:Any]? , completionHandler: @escaping (JSON?, String) -> ()) {
        Alamofire.request(url , method: .post, parameters: params,  encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
                case .success(let value):
                let data = JSON(value)
                let message = data["success"]
                if(message == "1") {
                    completionHandler(JSON(value), "Success")
                } else if (message == "0") {
                    completionHandler(nil, "Failed")
                }
                                     
                case .failure:
                    completionHandler(nil, "Network Failed")
            }
        }
    }
    

    func loadImageFromInternet(url : String, completionHandler: @escaping (Data, String) -> ()) {
        guard let url = URL(string: url) else { return }
        do {
            let data = try Data(contentsOf: url)
            completionHandler(data, "Success")
        } catch {
            print("Failed")
        }
    }
}
