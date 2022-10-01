//
//  ScheduleCardView.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 29.09.2022.
//

import SwiftUI

struct ScheduleCardView: View {
    @State var pairType: String
    @State var pairTime: String
    @State var pairTitle: String
    @State var pairClassRoom: String
    @State var pairTeacher: String
    @State var pairCount: String
    @State var pairColor: Color
    @State var pairPeriod: String
    func getTimePair() -> ClosedRange<Date> {
        return Date()...Date().addingTimeInterval(16000)
    }
    
    var body: some View {
        VStack {
            VStack (spacing:5) {
                HStack (alignment: .top, spacing: 15) {
                    ZStack {
                        Capsule(style: .continuous)
                            .foregroundColor(pairColor)
                            .frame(width: 20, height: 20, alignment: .leading)
                            .shadow(color: pairColor, radius: 2)
                        Text(pairCount)
                            .bold()
                            .font(.caption2)
                            .foregroundColor(Color.white)
                    }
                    Text(pairType)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .font(.subheadline)
                        .padding(.top, 2)
                    Spacer()
                    Text(pairTime)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        .font(.subheadline)
                        .foregroundColor(Color.primary.opacity(0.5))
                        .padding(.trailing, 5)
                }
                .frame(height: 15).padding(.all, 5).padding(.leading, 2).padding(.top, 3)
                VStack{
                    Text(pairTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 7)
                        .padding(.top, 5)
                    Text(pairTeacher)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 7)
                    
                }.offset(y: -4)
                
                Divider()
                HStack {
                    Text(pairClassRoom)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 7)
                    .padding(.vertical, 5)
                    Divider()
                    Text(pairPeriod)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 7)
                    .padding(.vertical, 5)
                }
                Spacer().frame(height: 0)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 10, height: 125, alignment: .center)
        .background(Color.gray.opacity(0.125))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.2))
    }
}

struct ScheduleCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleCardView(pairType: "Лекция", pairTime: "13:20 - 14:50", pairTitle: "Архитектура ЭВМ и компьютеров", pairClassRoom: "К-301", pairTeacher: "Урачев Павел Александрович", pairCount: "2", pairColor: Color.green, pairPeriod: "c 1 по 18 неделю")
    }
}
