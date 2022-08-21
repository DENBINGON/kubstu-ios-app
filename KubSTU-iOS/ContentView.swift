//
//  ContentView.swift
//  KubSTU iOS InfoApp
//
//  Created by Руслан Соловьев on 19.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    var titles : [String] = ["Расписания", "Информация", "Студенту", "Абитуриенту"]
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    ZStack {
                        NavBarButton()
                    
                    Image("KubSTU-Logo-white-trans-500x500")
                        .resizable()
                        .frame(width: 55, height: 55, alignment: .center)
                        .position(x: UIScreen.main.bounds.width / 2, y: 30)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
                .background(Color("AccentColor"))

                Spacer()

                ForEach (titles, id:\.self){ title in
                ElementPart(buttonText: title)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ElementPart: View {
    
    var buttonText: String = ""
    var buttonTextSecondary: String = ""
    
    var body: some View {
        ZStack{
            Capsule()
                .fill(Color("AccentColor"))
                .frame(width: UIScreen.main.bounds.width - 33, height: 92, alignment: .center)
            Capsule()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width - 35, height: 90, alignment: .center)
            VStack (spacing: 6) {
                Text(buttonText)
                    .bold()
                    .font(.title2)
                if (buttonTextSecondary != "") { Text(buttonTextSecondary)
                    .font(.body)
                    
                }
            }
                .frame(width: UIScreen.main.bounds.width - 100, height: 80, alignment: .center)
        }
        .shadow(color: Color("AccentColor").opacity(0.4), radius: 4, x: 0, y: 4)
        .padding(.bottom, 5)
    }
}

struct NavBarButton: View {
    var body: some View {
        VStack {
            ForEach ((0...2), id: \.self){ line in
                capsule
            }
        }
        .position(x: 0, y: 30)
        .padding(.leading, 35)
    }
    var capsule: some View {
        Capsule()
            .fill(Color.white)
            .frame(width: 40, height: 6, alignment: .center)
            
    }
}
