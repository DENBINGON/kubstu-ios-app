//
//  Enums.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 23.09.2022.
//

import SwiftUI
enum Resources {
    
    enum Images {
        
        static var news = Image(systemName: "newspaper")
        static var find = Image(systemName:"magnifyingglass")
        static var schedule = Image(systemName:"calendar")
        static var user = Image(systemName:"gear")
        static var logo = Image("KubSTU-Logo-blue-trans-300x300")
    }
    
    enum Colors {
        static var accent = Color.accentColor
        static var darkestAvailable = Color("darkAvailable")
        static var newsCard = Color("NewsCardColor")
        static var background = Color("background")
        static var forgereground = Color("Forgeground")
    }
}
