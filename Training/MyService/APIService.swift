//
//  NewsItemViewModel.swift
//  Training
//
//  Created by ManhLD on 12/10/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var baseURL = "http://a1f66b60.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/"

class getDataService {
    
    class var getInstance: getDataService {
         struct Static {
             static let instance: getDataService = getDataService()
         }
         return Static.instance
     }
    
    open func getListNews(pageIndex : Int, pageSize : Int, completionHandler: @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "listNews?pageIndex=\(pageIndex)&pageSize=\(pageSize)", method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
            let response = JSON(value)
            let data = response["response"]["news"]
            completionHandler(data, 1)
            case .failure( _):
            completionHandler(nil, 0)
            }
        }
    }
    
    open func getListPopular(pageIndex: Int, pageSize: Int, completionHandler : @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "listPopularEvents?pageIndex=\(pageIndex)&pageSize=\(pageSize)" , method: .get, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                let response = JSON(value)
                let data = response["response"]["events"]
                completionHandler(data, 1)
                case .failure( _):
                completionHandler(nil, 0)
            }
        }
    }
    
    
    open func getListCategories(completionHandler : @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "listCategories" , method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
            let response = JSON(value)
            let data = response["response"]["categories"]
            completionHandler(data, 1)
            case .failure( _):
            completionHandler(nil, 0)
            }
        }
    }
    
    func register(params: [String : String], completionHandler : @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "register", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
            let response = JSON(value)
            let data = response["response"]
            completionHandler(data, 1)
            case .failure( _):
            completionHandler(nil, 0)
            }
        }
    }
    
    func login(params : [String : String], completionHandler : @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
            let response = JSON(value)
            let data = response["response"]
            completionHandler(data, 1)
            case .failure( _):
            completionHandler(nil, 0)
            }
        }
    }
}
