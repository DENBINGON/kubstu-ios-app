//
//  ContentView.swift
//  KubSTU iOS InfoApp
//
//  Created by Руслан Соловьев on 19.08.2022.
//

import SwiftUI

import SwiftUI
struct MainView: View {
    @State private var selectedIndexView = 0
    var body: some View {
        VStack {
            // Body
            HStack{}.frame(width: UIScreen.main.bounds.width, height: 70)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 3).foregroundColor(Color.accentColor).padding(.horizontal, 5))

            VStack {
                withAnimation(Animation.easeInOut) {
                    selectedIndexView == 0 ? AnyView(NewsView()) :
                            (selectedIndexView == 1 ? AnyView(FindView()) :
                                    (selectedIndexView == 3 ? AnyView(ScheduleView()) :
                                            (selectedIndexView == 4 ? AnyView(SettingsView()) : AnyView(UniversityView()))))
                }
            }


            Spacer()

            // NavBar
            Divider()
            VStack{
                ZStack {
                HStack {

                    Button(action: { selectedIndexView = 0 })
                    {
                        VStack{
                        Resources.Images.news
                                .resizable()
                                .frame(width: 32, height: 32)
                            }
                    }
                            .foregroundColor(selectedIndexView == 0 ? Color.accentColor : .gray)
                    Spacer(minLength: 16)
                    Button(action: { selectedIndexView = 1 }) {
                        Resources.Images.find
                                .resizable()
                                .frame(width: 32, height: 32)

                    }
                            .foregroundColor(selectedIndexView == 1 ? Color.accentColor : .gray)

                    Spacer().frame(width: 125)
                    Button(action: { selectedIndexView = 3 }) {
                        Resources.Images.schedule
                                .resizable()
                                .frame(width: 32, height: 32)

                    }
                            .foregroundColor(selectedIndexView == 3 ? Color.accentColor : .gray)

                    Spacer(minLength: 16)
                    Button(action: { selectedIndexView = 4 }) {
                        Resources.Images.user
                                .resizable()
                                .frame(width: 32, height: 32)
                    }
                            .foregroundColor(selectedIndexView == 4 ? Color.accentColor : .gray)
                }
                        .padding()
                        .padding(.horizontal, 15)

                Button(action: { selectedIndexView = 2 }) {
                    Resources.Images.logo
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 42, height: 42)
                            .padding(.all, 6)
                }//.foregroundColor(Color.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: selectedIndexView == 2 ? Color.accentColor.opacity(0.5) : Color.black.opacity(0.5), radius: 6)
                        .animation(.easeInOut)
            }
            }
        }
//                .edgesIgnoringSafeArea(.top)
    }
}



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct NewsView: View{
    var body: some View{
        VStack {
            ScrollView(showsIndicators: false) {
            ForEach (1..<2) { element in
                CardView()
            }
            }
        }
    }
}

struct FindView: View {
    var body: some View {
        Text("FindView")
    }
}
struct UniversityView: View {
    var body: some View {
        Text("UniversityView")
    }
}
struct ScheduleView: View {
    var body: some View {
        Text("ScheduleView")
    }
}
struct SettingsView: View {
    var body: some View {
        Text("SettingsView")
    }
}

struct CardView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 20) {
                Image(systemName: "command")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.accentColor.opacity(0.7), radius: 3)
                        .padding()
                        .cornerRadius(30)
                        .foregroundColor(Color.accentColor.opacity(0.7))
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 2).foregroundColor(Color.gray.opacity(0.35)))
                VStack(spacing:3) {
                    Text("Заголовок")
                            .bold()
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)


                    Text("Краткое описаниеКраткое описаниеКраткое описаниеКраткое описаниеКраткое описаниеКраткое описание")
                        .font(.custom("", size: 13))
                }
                Spacer(minLength: 0)
            }
                    .padding()

            Spacer()
        }
                .frame(width: UIScreen.main.bounds.width - 24, height: 150)
                .background(Color.white)
                
                .overlay(
                        RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.35), lineWidth: 2)
                )
            
                .padding(.all, 3)
    }
}
