//
//  KubSTU_iOSApp.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 19.08.2022.
//

import SwiftUI
import SwiftyJSON
@main
struct KubSTU_iOSApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView().onAppear {
                let defaults = UserDefaults.standard
                let urlString = "student/21-КБ-ПИ1"
                if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                   let url = URL(string: "https://api.ruslansoloviev.ru/" +  urlString) {
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if data != nil {
                            defaults.set(String(decoding: data!, as: UTF8.self), forKey: "schedule")
                        }
                    }
                    task.resume()
                }
            }
        }
    }
}
