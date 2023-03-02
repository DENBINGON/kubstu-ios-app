//
//  ContentView.swift
//  KubSTU iOS InfoApp
//
//  Created by Руслан Соловьев on 19.08.2022.
//

import SwiftUI
import Foundation


struct MainView: View {
    @State var selectedIndexView: Int = 0
    @State var text: String = ""
    @State var bannerView: any View = Text("").frame(width: 0, height: 0, alignment: .center).hidden()
    let defaults = UserDefaults.standard
    var body: some View {
        VStack {
            TabView {
                NewsView().tabItem {
                    Resources.Images.news
                    Text("Новости")
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
                    Text("Настройки")
                }
            }
        }
        .accentColor(Resources.Colors.forgereground)
        .onAppear {
            let banner: any View = BannerView().frame(width: UIScreen.main.bounds.width, height: 32, alignment: .center)
            bannerView = banner
        }
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()

    }
}







