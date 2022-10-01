//
//  ContentView.swift
//  KubSTU iOS InfoApp
//
//  Created by Руслан Соловьев on 19.08.2022.
//

import SwiftUI
import Foundation
struct MainView: View {
    @State private var selectedIndexView = 0
    @State var text: String = ""
    var body: some View {
        VStack {
            TabView {
                NewsView().tabItem {
                    Resources.Images.news
                    Text("Новости").font(.title)
                }
                FindView().tabItem {
                    Resources.Images.find
                    Text("Поиск")
                }
                ScheduleView().tabItem {
                    Resources.Images.schedule
                    Text("Расписание")
                }
                UserView().tabItem {
                    Resources.Images.user
                    Text("Профиль")
                }
            }
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.light)
        MainView().preferredColorScheme(.dark)

    }
}







