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
import RealmSwift


class NetWorkService {
    
    class var getInstance: NetWorkService {
         struct Static {
             static let instance: NetWorkService = NetWorkService()
         }
         return Static.instance
     }
    
    public func getRequestAPI(url: String, headers : HTTPHeaders? = nil, params : [String : Any]? = nil, completionHandler: @escaping (JSON?, Int) -> ()) {
          Alamofire.request(url , method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
              switch response.result {
                  case .success(let value):
                    completionHandler(JSON(value), 1)
                  case .failure( _):
                    completionHandler(nil, 0)
              }
          }
      }

    
    public func postRequestAPI(url: String, params: [String:Any]?, headers : HTTPHeaders? = nil, completionHandler: @escaping (JSON?, Int) -> ()) {
        Alamofire.request(url , method: .post, parameters: params,  encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
                case .success(let value):
                    completionHandler(JSON(value), 1)
                case .failure( _):
                    completionHandler(nil, 0)
            }
        }
    }
    

    public func loadImageFromInternet(url : String, completionHandler: @escaping (Data, String) -> ()) {
        guard let url = URL(string: url) else { return }
        do {
            let data = try Data(contentsOf: url)
            completionHandler(data, "Success")
        } catch {
            print("Failed")
        }
    }
}
