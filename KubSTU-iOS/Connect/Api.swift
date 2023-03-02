//
//  File.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 04.10.2022.
//
import SwiftyJSON
import Foundation

class Api {
    let uri: String = "https://api.ruslansoloviev.ru/"
    let defaults = UserDefaults.standard
    
    init() {
        let urlString = "student/groups".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = URL(string: self.uri +  urlString!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if data != nil {
                self.defaults.set(String(decoding: data!, as: UTF8.self), forKey: "all-groups")
            }
        }
        task.resume()
    }
    
    public func getNewSchedule() -> Void {
        let urlString = "student/\(self.defaults.string(forKey: "user-group")!)"
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
           let url = URL(string: self.uri +  urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if data != nil {
                    self.defaults.set(String(decoding: data!, as: UTF8.self), forKey: "schedule")
                }
            }
            task.resume()
        }
    }

    public func getJSON(data: String) -> JSON {
        let urlString = data.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = URL(string: self.uri +  urlString!)
        if let data = try? Data(contentsOf: url!)
        {
            return JSON(parseJSON: String(decoding: data, as: UTF8.self))
        }
        return JSON(parseJSON: "['error']")
    }

    
    public func groupValidate(user_group: String) -> Bool {
        if self.defaults.string(forKey: "all-groups") != nil {
            let groupsJSON: JSON = JSON(parseJSON: self.defaults.string(forKey: "all-groups")!)
            for group in groupsJSON.arrayValue {
                if user_group == group.stringValue {
                    if self.getJSON(data: "student/check/\(user_group)")["check"] == true{
                        return true
                    }
                }
            }
        }
        return false
    }
}



