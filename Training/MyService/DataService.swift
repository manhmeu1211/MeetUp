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
import RealmSwift
import UIKit


class DataService : UIViewController {
    
   let baseURL = "http://meetup.rikkei.org/api/v0/"
    
    let realm = try! Realm()
    
    private func deleteObject(object : Object.Type) {
           let list = realm.objects(object).toArray(ofType: object)
           try! realm.write {
               realm.delete(list)
           }
       }
    
    func getListNews(pageIndex : Int, pageSize : Int, shoudLoadmore: Bool, completionHandler: @escaping ([NewsDataResponse], Int) -> ()) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "listNews?pageIndex=\(pageIndex)&pageSize=\(pageSize)", headers: nil, params: nil) {
            (response, errCode) in
            if errCode == 1 {
                let data = response!["response"]["news"]
                if shoudLoadmore == false {
                    self.deleteObject(object: NewsDataResponse.self)
                    _ = data.array?.forEach({ (news) in
                        let news = NewsDataResponse(news: news)
                        RealmDataBaseQuery.getInstance.addData(object: news)
                    })
                } else {
                    _ = data.array?.forEach({ (news) in
                        let news = NewsDataResponse(news: news)
                        RealmDataBaseQuery.getInstance.addData(object: news)
                    })
                }
                let dataLoaded = RealmDataBaseQuery.getInstance.getObjects(type: NewsDataResponse.self)?.toArray(ofType: NewsDataResponse.self)
                completionHandler(dataLoaded!, 1)
            } else {
                completionHandler([], 0)
            }
            
        }
    }
    
    func getListPopular(pageIndex: Int, pageSize: Int, headers: HTTPHeaders, isLoadmore : Bool, completionHandler : @escaping ([PopularsResDatabase], Int) -> ()) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "listPopularEvents?pageIndex=\(pageIndex)&pageSize=\(pageSize)", headers: headers, params: nil) {
            (response, errCode) in
            if errCode == 1 {
                let data = response!["response"]["events"]
                if isLoadmore == false {
                    self.deleteObject(object: PopularsResDatabase.self)
                    _ = data.array?.forEach({ (populars) in
                        let populars = PopularsResDatabase(populars: populars )
                        RealmDataBaseQuery.getInstance.addData(object: populars)
                    })
                } else {
                    _ = data.array?.forEach({ (populars) in
                        let populars = PopularsResDatabase(populars: populars)
                        RealmDataBaseQuery.getInstance.addData(object: populars)
                    })
                }
                let dataLoaded = RealmDataBaseQuery.getInstance.getObjects(type: PopularsResDatabase.self)?.toArray(ofType: PopularsResDatabase.self)
                completionHandler(dataLoaded!, 1)
            } else {
                completionHandler([], 0)
            }
            
        }
    }
    
    
    func getListCategories(completionHandler : @escaping ([CategoriesResDatabase], Int) -> ()) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "listCategories", headers: nil, params: nil) { (response, errCode) in
            if errCode == 1 {
                let data = response!["response"]["categories"]
                self.deleteObject(object: CategoriesResDatabase.self)
                _ = data.array?.forEach({ (cate) in
                    let categories = CategoriesResDatabase(cate: cate)
                RealmDataBaseQuery.getInstance.addData(object: categories)
                })
                let dataLoaded = RealmDataBaseQuery.getInstance.getObjects(type: CategoriesResDatabase.self)?.toArray(ofType: CategoriesResDatabase.self)
                completionHandler(dataLoaded!, 1)
            } else {
                completionHandler([], 0)
            }
            
        }
    }
    
    
    func getListNearEvent(radius: Double, longitue : Double, latitude : Double, header: HTTPHeaders, completionHandler : @escaping ([EventsNearResponse], JSON?, Int) ->()) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "listNearlyEvents?radius=\(radius)&longitue=\(longitue)&latitude=\(latitude)", headers: header, params: nil) { (response, errCode) in
            if errCode == 1 {
                let status = response!["status"].intValue
                if status == 0 {
                    let message = response!["error_message"]
                    completionHandler([], message, 1)
                } else {
                    let data = response!["response"]["events"]
                    self.deleteObject(object: EventsNearResponse.self)
                    _ = data.array?.forEach({ (events) in
                        let events = EventsNearResponse(events: events)
                    RealmDataBaseQuery.getInstance.addData(object: events)
                    })
                    let dataLoaded = RealmDataBaseQuery.getInstance.getObjects(type: EventsNearResponse.self)?.toArray(ofType: EventsNearResponse.self)
                    completionHandler(dataLoaded!, data, 2)
                }
            } else {
                completionHandler([], nil ,0)
            }
        }
    }
    
    
    func search(pageIndex: Int, pageSize : Int, keyword : String, header: HTTPHeaders, isLoadMore : Bool, completionHandler: @escaping ([SearchResponseDatabase], Int) -> ()) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "search?pageIndex=\(pageIndex)&pageSize=\(pageSize)&keyword=\(keyword)" , headers: header, params: nil) { (response, errCode) in
            if errCode == 1 {
                let status = response!["status"].intValue
                if status == 0 {
                    let message = response!["error_message"]
                    print(message)
                    completionHandler([], 1)
                } else {
                    let data = response!["response"]["events"]
                    if isLoadMore == false {
                        self.deleteObject(object: SearchResponseDatabase.self)
                        _ = data.array?.forEach({ (search) in
                            let searchRes = SearchResponseDatabase(search: search)
                            RealmDataBaseQuery.getInstance.addData(object: searchRes)
                        })
                    } else {
                        _ = data.array?.forEach({ (search) in
                            let searchRes = SearchResponseDatabase(search: search)
                            RealmDataBaseQuery.getInstance.addData(object: searchRes)
                        })
                    }
                    let searchResult = RealmDataBaseQuery.getInstance.getObjects(type: SearchResponseDatabase.self)?.toArray(ofType: SearchResponseDatabase.self)
                    completionHandler(searchResult!, 2)
                }
            } else {
                completionHandler([], 0)
            }
        }
        
    }
    
    
    func getListEventsByCategories(id: Int, pageIndex : Int, headers: HTTPHeaders, isLoadMore : Bool, completionHandler : @escaping ([EventsByCategoriesDatabase], Int) ->()) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "listEventsByCategory?category_id=\(id)&pageIndex=\(pageIndex)&pageSize=10", headers: headers, params: nil) { (response, errCode) in
            if errCode == 1 {
                let status = response!["status"]
                if status == 0 {
                    let data = response!["error_message"]
                    print(data)
                    completionHandler([], 1)
                } else {
                    let data = response!["response"]["events"]
                        if isLoadMore == false {
                            self.deleteObject(object: EventsByCategoriesDatabase.self)
                            _ = data.array?.forEach({ (event) in
                            let eventsRes = EventsByCategoriesDatabase(event: event)
                            RealmDataBaseQuery.getInstance.addData(object: eventsRes)
                            })
                        } else {
                            _ = data.array?.forEach({ (event) in
                            let eventsRes = EventsByCategoriesDatabase(event: event)
                            RealmDataBaseQuery.getInstance.addData(object: eventsRes)
                            })
                        }
                    let eventByCate = RealmDataBaseQuery.getInstance.getObjects(type: EventsByCategoriesDatabase.self)?.toArray(ofType: EventsByCategoriesDatabase.self)
                    completionHandler(eventByCate!, 2)
                }
            } else {
                completionHandler([], 0)
            }
        }
    }
    
   func getMyEventGoing(status : Int, headers : HTTPHeaders, completionHandler : @escaping([MyPageGoingResDatabase], Int) -> ()) {

        NetWorkService.getInstance.getRequestAPI(url: baseURL + "listMyEvents?status=\(status)", headers: headers, params: nil) { (response, errCode) in
            if errCode == 1 {
                let status = response!["status"]
                if status == 0 {
                    let data = response!["error_message"]
                    print(data)
                    completionHandler([], 1)
                } else {
                    let data = response!["response"]["events"]
                    self.deleteObject(object: MyPageGoingResDatabase.self)
                       _ = data.array?.forEach({ (goingEvents) in
                       let goingEvents = MyPageGoingResDatabase(goingEvents: goingEvents)
                       RealmDataBaseQuery.getInstance.addData(object: goingEvents)
                   })
                    let dataLoaded = RealmDataBaseQuery.getInstance.getObjects(type: MyPageGoingResDatabase.self)?.toArray(ofType: MyPageGoingResDatabase.self)
                    completionHandler(dataLoaded!, 2)
                }
            } else {
                completionHandler([], 0)
            }
        }
    }
    

   func getMyEventWent(status : Int, headers : HTTPHeaders, completionHandler : @escaping([MyPageWentResDatabase], Int) -> ()) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "listMyEvents?status=\(status)", headers: headers, params: nil) { (response, errCode) in
            if errCode == 1 {
                let status = response!["status"]
                if status == 0 {
                    let data = response!["error_message"]
                    print(data)
                    completionHandler([], 1)
                } else {
                    let data = response!["response"]["events"]
                    self.deleteObject(object: MyPageWentResDatabase.self)
                       _ = data.array?.forEach({ (goingEvents) in
                       let goingEvents = MyPageWentResDatabase(goingEvents: goingEvents)
                       RealmDataBaseQuery.getInstance.addData(object: goingEvents)
                   })
                    let dataLoaded = RealmDataBaseQuery.getInstance.getObjects(type: MyPageWentResDatabase.self)?.toArray(ofType: MyPageWentResDatabase.self)
                    completionHandler(dataLoaded!, 2)
                }
            } else {
                completionHandler([], 0)
            }
        }
    }
    
    func getEventDetail(idEvent : Int, headers : HTTPHeaders, completionHandler : @escaping(EventDetail, Int) -> () ) {
        NetWorkService.getInstance.getRequestAPI(url: baseURL + "getDetailEvent?event_id=\(idEvent)", headers: headers, params: nil) { (response, errCode) in
            if errCode == 1 {
                let status = response!["status"].intValue
                if status == 0 {
                    let data = response!["error_code"].intValue
                    print(data)
                    completionHandler(EventDetail(id: 0, photo: "", name: "Failed to load", descriptionHtml: "", scheduleStartDate: "", scheduleEndDate: "", scheduleStartTime: "", scheduleEndTime: "", schedulePermanent: "", goingCount: 0, nameGenre: "", vnLocation: "", vnContact: "", vnName: ""), 1)
                } else {
                    self.deleteObject(object: EventDetail.self)
                    let data = response!["response"]["events"]
                    let detailVenue = data["venue"]
                    let detailGenre = data["category"]
                    let eventDetail = EventDetail(detail: data, detailVenue: detailVenue, detailGenre: detailGenre)
                     RealmDataBaseQuery.getInstance.addData(object: eventDetail)
                    completionHandler(eventDetail, 2)
                }
            } else {
                 completionHandler(EventDetail(id: 0, photo: "", name: "Failed to load", descriptionHtml: "", scheduleStartDate: "", scheduleEndDate: "", scheduleStartTime: "", scheduleEndTime: "", schedulePermanent: "", goingCount: 0, nameGenre: "", vnLocation: "", vnContact: "", vnName: ""), 0)
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
    
    func resetPassword(params : [String : String], completionHandler : @escaping (JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "resetPassword", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { (response) in
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
    
    func doUpdateEvent(params : [String : Any], headers : HTTPHeaders, completionHandler : @escaping(JSON?, Int) -> ()) {
        Alamofire.request(baseURL + "doUpdateEvent", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
              switch response.result {
                case .success(let value):
                let response = JSON(value)
                let status = response["status"]
                if status == 0 {
                    let data = response["error_message"]
                    completionHandler(data, 1)
                } else {
                    completionHandler(status, 2)
                }
                case .failure( _):
                completionHandler(nil, 0)
            }
        }
    }
}
