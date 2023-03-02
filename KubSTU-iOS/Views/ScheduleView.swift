//
//  ScheduleView.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 29.09.2022.
//

import SwiftUI
import SwiftyJSON

struct ScheduleView: View {
    let defaults: UserDefaults = UserDefaults.standard
    @State var json: JSON = JSON(parseJSON: "")
    @State var date: Date = Date()
    @State var weekEven: Int = 1
    @State var dayNumber: Int = 1
    @State var pairStrings: [String] = []
    @State var nilDefaults: Bool = true
    @State var tabViewIndex: Int = 1
//    let ad: any View
    let seconds: [Int] = [-86400, 0, 86400]
    let weekDays: [String] = [
        "Воскресенье",
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота"
    ]
    @State var dateString: String = ""
    
    private func setDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "RU")
        return formatter.string(from: self.date)
    }
    
    private func getDailyJSON(date: Date) -> JSON {
        let weekJSON: JSON = self.json[self.getWeekEven(date: date)]["schedule"]
        let dayTitle = self.weekDays[self.getDayNumber(date: date)]
        for dayCounter in 0..<7 {
            if dayTitle == weekJSON[dayCounter]["day"].stringValue{
                return weekJSON[dayCounter]
            }
        }
        return self.json
    }
    
    private func getWeekEven(date: Date) -> Int {
        let Calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let Components = Calendar.components(.weekOfYear, from: date)
        return (self.weekDays[self.getDayNumber(date: self.date)] == self.weekDays[0] ? (Components.weekOfYear! - 1) % 2 == 1 ? 1 : 0 : (Components.weekOfYear! - 1) % 2 == 1 ? 0 : 1) == 1 ? 0 : 1 //ТУТ ШПАКЛЕВКА
    }
    private func getDayNumber(date: Date) -> Int {
        let Calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let Components = Calendar.components(.weekday, from: date)
        return Components.weekday! - 1
        
    }
    private func getDailyPairStrings(date: Date) -> [String] {
        var response: [String] = []
        for obj in self.getDailyJSON(date: date)["pairs"].arrayValue{
            response.append(obj.description)
        }
        return response
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Spacer().frame(height: 5)
                        ZStack {
                            Text(String(self.weekDays[self.getDayNumber(date: self.date)] + ", \(self.weekEven == 0 ? "нечётная" : "четная") неделя"))
                                .lineLimit(1)
                                .font(.subheadline)
                                .frame(maxWidth: UIScreen.main.bounds.width - 5, maxHeight: .infinity, alignment: .center)
                        }
                        .padding(.all, 5)
                        .frame(maxWidth: UIScreen.main.bounds.width - 10, maxHeight: .infinity, alignment: .center)
                        .background(Resources.Colors.darkestAvailable)
                        .cornerRadius(5)
                        .shadow(radius: 1)
                        .padding(.bottom, 3)
                        DayEventsView(nilDefaults: self.nilDefaults, pairStrings: self.getDailyPairStrings(date: self.date), selectedDate: self.date)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
                Spacer()
//                AnyView(ad).frame(width: UIScreen.main.bounds.width, height: 32, alignment: .center)

            }
            .padding(.top, 42)
            .background(Resources.Colors.background)
        

            .gesture(DragGesture()
                .onEnded({ value in
                    withAnimation {
                        if value.translation.width < -80 {
                            self.date.addTimeInterval(86400)
                        }
                        else if value.translation.width > 80 {
                            self.date.addTimeInterval(-86400)
                        }
                    }
                }))
            .onAppear(perform: {
                self.weekEven = self.getWeekEven(date: self.date)
                self.dayNumber = self.getDayNumber(date: self.date)
                if self.defaults.string(forKey: "schedule") != nil {
                    self.json = JSON(parseJSON: self.defaults.string(forKey: "schedule")!)
                    nilDefaults = false
                }
                else {
                    nilDefaults = true
                }
                self.dateString = self.setDateString()
                self.pairStrings = []
                for obj in self.getDailyJSON(date: self.date)["pairs"].arrayValue{
                    self.pairStrings.append(obj.description)
                }
            })
            VStack {
                HStack {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .onChange(of: date, perform: { v in
                            self.weekEven = self.getWeekEven(date: self.date)
                            self.dayNumber = self.getDayNumber(date: self.date)
                            self.dateString = setDateString()
                            self.pairStrings = []
                            for obj in self.getDailyJSON(date: self.date)["pairs"].arrayValue{
                                self.pairStrings.append(obj.description)
                            }
                        })
                    HStack (spacing: 20) {
                        Spacer()
                        ForEach ( [-86400, 86400], id: \.self ) { element in
                            Button  {
                                self.date.addTimeInterval(TimeInterval(element))
                            } label: {
                                ButtonOnView(image: Image(systemName: element > 0 ? "arrow.right" : "arrow.left"))
                            }
                        }
                        
                    }.padding(.trailing, 10)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                .frame(width: UIScreen.main.bounds.width, height: 40, alignment: .center)
                .background(Resources.Colors.darkestAvailable)
                Spacer()

            }
            
                
        }.background(Resources.Colors.darkestAvailable)
    }
}


struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}


struct DayEventsView: View {
    
    var nilDefaults: Bool
    var pairStrings: [String]
    var selectedDate: Date
    var body: some View{
        VStack (spacing: 7) {
            ForEach(self.pairStrings != [] ? self.pairStrings : [""], id: \.self){ element in
                if self.nilDefaults == true {
                    let defaults = UserDefaults.standard
                    if defaults.string(forKey: "user-group") == nil {
                        EventCardView(emoji: "👉👈", text: "Добавь группу в профиле ;)")
                    }
                    else {
                        EventCardView(emoji: "😔", text: "Не могу получить информацию :(")
                        
                    }
                }
                else if self.pairStrings != [] {
                    let pairJSON = JSON(parseJSON: element)
                    ScheduleCardView(pairType: pairJSON["type"].stringValue,
                                     pairTime: pairJSON["time"].stringValue,
                                     pairTitle: pairJSON["title"].stringValue,
                                     pairClassRoom: pairJSON["classroom"].stringValue,
                                     pairTeacher: pairJSON["teacher"].stringValue,
//                                     pairCount: String(self.pairStrings.firstIndex(of: element)! + 1),
//                                     pairColor: Color.green,
                                     pairPeriod: pairJSON["period"].stringValue,
                                     selectedDate: self.selectedDate)
                }
                else {
                    EventCardView(emoji: "🥳", text: "Сегодня пар нет ;)")
                }
            }
        }
    }
}


struct ButtonOnView :View {
    @State var image: Image
    var body: some View {
        HStack{
            self.image
                .scaleEffect(0.7)
        }
        .frame(width: 25, height: 20, alignment: .center)
        .background(Resources.Colors.darkestAvailable)
        .cornerRadius(5)
        .shadow(radius: 1)
        .scaleEffect(1.5)
    }
}


struct EventCardView: View {
    
    @State var emoji: String
    @State var text: String
    
    var body: some View {
        VStack (spacing:50){
            Text(self.emoji)
                .font(.custom("", size: 80) )
                .frame(maxWidth: .infinity, alignment: .center)
            Text(self.text)
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)

        }
        .frame(width: 300, height: 300, alignment: .center)
        .background(Resources.Colors.newsCard)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.top, 7)
    }
}
