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


class getDataService {
    
   let baseURL = "http://b9acd944.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/"
    
    class var getInstance: getDataService {
         struct Static {
             static let instance: getDataService = getDataService()
         }
         return Static.instance
     }
    
    open func getListNews(pageIndex : Int, pageSize : Int, completionHandler: @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "listNews?pageIndex=\(pageIndex)&pageSize=\(pageSize)", method: .get, encoding: JSONEncoding.default).validate().responseJSON { (response) in
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
        Alamofire.request(baseURL + "listPopularEvents?pageIndex=\(pageIndex)&pageSize=\(pageSize)" , method: .get, encoding: JSONEncoding.default).validate().responseJSON { response in
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
            let status = response["status"]
            var data = response["response"]
            if status == 0 {
                data = response["error_message"]
                completionHandler(data, 1)
            } else {
                data = response["response"]
                completionHandler(data, 2)
            }
            case .failure( _):
            completionHandler(nil, 0)
            }
        }
    }
    
    func getListNearEvent(radius: Double, longitue : Double, latitude : Double, header: HTTPHeaders,completionHandler : @escaping (JSON?, Int) ->()) {
        Alamofire.request(baseURL + "listNearlyEvents?radius=\(radius)&longitue=\(longitue)&latitude=\(latitude)", method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
    
    
    func search(pageIndex: Int, pageSize : Int, keyword : String, header: HTTPHeaders, completionHandler: @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "search?pageIndex=\(pageIndex)&pageSize=\(pageSize)&keyword=\(keyword)", method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let response = JSON(value)
                    let status = response["status"]
                    var data = response["response"]
                    if status == 0 {
                        data = response["error_message"]
                        completionHandler(data, 1)
                    } else {
                        data = response["response"]["events"]
                        completionHandler(data, 2)
                    }
                    
                case .failure( _):
                    completionHandler(nil, 0)
            }
        }
    }
    
    
    func getListEventsByCategories(id: Int, pageIndex : Int, headers: HTTPHeaders, completionHandler : @escaping (JSON?, Int) ->()) {
        Alamofire.request(baseURL + "listEventsByCategory?category_id=\(id)&pageIndex=\(pageIndex)&pageSize=10", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let response = JSON(value)
                    let status = response["status"]
                    var data = response["response"]
                    if status == 0 {
                        data = response["error_message"]
                        completionHandler(data, 1)
                    } else {
                        data = response["response"]["events"]
                        completionHandler(data, 2)
                    }
                case .failure( _):
                    completionHandler(nil, 0)
            }
        }
    }
    
    func getMyEventGoing(status : Int, headers : HTTPHeaders, completionHandler : @escaping(JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "listMyEvents?status=\(status)", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
             switch response.result {
                case .success(let value):
                let response = JSON(value)
                let status = response["status"]
                var data = response["response"]
                if status == 0 {
                    data = response["error_message"]
                    completionHandler(data, 1)
                } else {
                    data = response["response"]["events"]
                    completionHandler(data, 2)
                }
            case .failure( _):
                completionHandler(nil, 0)
            }
        }
    }
    
    
    func getMyEventWent(status : Int, headers : HTTPHeaders, completionHandler : @escaping(JSON?, Int) -> ()) {
           Alamofire.request(baseURL + "listMyEvents?status=\(status)", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                switch response.result {
                   case .success(let value):
                   let response = JSON(value)
                   let status = response["status"]
                   var data = response["response"]
                   if status == 0 {
                       data = response["error_message"]
                       completionHandler(data, 1)
                   } else {
                       data = response["response"]["events"]
                       completionHandler(data, 2)
                   }
               case .failure( _):
                   completionHandler(nil, 0)
               }
           }
       }
}
