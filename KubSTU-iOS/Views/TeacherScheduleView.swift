//
//  TeacherScheduleView.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 04.10.2022.
//

import SwiftyJSON
import SwiftUI

struct TeacherScheduleView: View {
    let defaults = UserDefaults.standard
    let teacher: JSON
    let api: Api = Api()
    @State var json: JSON = JSON(parseJSON: "")
    @State var date: Date = Date()
    @State var weekEven: Int = 1
    @State var dayNumber: Int = 1
    @State var pairStrings: [String] = []
    @State var nilDefaults: Bool = true
    @State var tabViewIndex: Int = 1
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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "chevron.backward")
                .aspectRatio(contentMode: .fit)
        }
    }
    }
    
    private func setDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "RU")
        return formatter.string(from: self.date)
    }
    
    private func getDailyJSON(date: Date) -> [JSON] {
        var currentDayPairs: [JSON] = []
        let currentEven: Int = self.weekEven == 1 ? 2 : 1
        for (_, currentPair) in self.json {
            if currentPair["even"].intValue == currentEven && currentPair["day"].stringValue == self.weekDays[self.dayNumber] {
                currentDayPairs.append(currentPair)
            }
        }
        return currentDayPairs
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
        for obj in self.getDailyJSON(date: self.date){
            let add = [
                "title": obj["pair_name"],
                "period": obj["period"],
                "type": obj["type"],
                "classroom": obj["classroom"],
                "time": obj["time"]
            ]
            response.append(JSON(add).description)
        }
        return response
    }
    
    var body: some View {
        NavigationView {
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
                        TeacherDayEventsView(nilArray: self.json.isEmpty, pairStrings: self.pairStrings, selectedDate: self.date)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
                Spacer()
            }
            .toolbar(content: {
                
                HStack () {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .onChange(of: date, perform: { v in
                            self.weekEven = self.getWeekEven(date: self.date)
                            self.dayNumber = self.getDayNumber(date: self.date)
                            self.dateString = setDateString()
                            self.pairStrings = []
                            for obj in self.getDailyJSON(date: self.date){
                                let add = [
                                    "title": obj["pair_name"],
                                    "period": obj["period"],
                                    "type": obj["type"],
                                    "classroom": obj["classroom"],
                                    "time": obj["time"]
                                ]
                                self.pairStrings.append(JSON(add).description)
                            }
                        })
                    HStack (spacing: 20) {
                        Spacer()
                        ForEach ( [-86400, 86400], id: \.self ) { element in
                            Button  {
                                self.date.addTimeInterval(TimeInterval(element))
                            } label: {
                                HStack{
                                    Image(systemName: element > 0 ? "arrow.right" : "arrow.left").scaleEffect(0.7)
                                }
                                .frame(width: 25, height: 20, alignment: .center)
                                .background(Resources.Colors.darkestAvailable)
                                .cornerRadius(5)
                                .shadow(radius: 1)
                                .scaleEffect(1.5)
                            }
                        }
                        
                    }.padding(.trailing, 10)
                }
                .padding(.horizontal, 10)
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
                .padding(.bottom, 5)
            })
            .navigationBarTitleDisplayMode(.inline)
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
                if self.defaults.stringArray(forKey: "latest-selected-teachers") != nil {
                    var currentVersion: [String] = self.defaults.stringArray(forKey: "latest-selected-teachers")!
                    if currentVersion.count > 5 && !currentVersion.contains(self.teacher.description) {
                        currentVersion.remove(at: currentVersion.startIndex)
                        currentVersion.append(self.teacher.description)
                    }
                    else if !currentVersion.contains(self.teacher.description) {
                        currentVersion.append(self.teacher.description)
                    }
                    else if currentVersion.contains(self.teacher.description) {
                        let indexSelectedComponent = currentVersion.firstIndex(of: self.teacher.description)
                        currentVersion.swapAt(indexSelectedComponent!, 0)
                    }
                    self.defaults.set(currentVersion, forKey: "latest-selected-teachers")
                }
                else {
                    self.defaults.set([self.teacher.description], forKey: "latest-selected-teachers")
                }
                
                self.weekEven = self.getWeekEven(date: self.date)
                self.dayNumber = self.getDayNumber(date: self.date)
                self.json = api.getJSON(data: "teacher/full/\(teacher["surname"].stringValue).\(teacher["name"].stringValue).\(teacher["patronymic"].stringValue)")
                self.dateString = self.setDateString()
                self.pairStrings = []
                for obj in self.getDailyJSON(date: self.date){
                    let add = [
                        "title": obj["pair_name"],
                        "period": obj["period"],
                        "type": obj["type"],
                        "classroom": obj["classroom"],
                        "time": obj["time"]
                    ]
                    self.pairStrings.append(JSON(add).description)
                }
            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("\(teacher["surname"].stringValue) \(teacher["name"].stringValue) \(teacher["patronymic"].stringValue)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: btnBack)
        
    }
}

struct TeacherDayEventsView: View {
    
    var nilArray: Bool
    var pairStrings: [String]
    var selectedDate: Date
    var body: some View{
        VStack (spacing: 7) {
            ForEach(self.pairStrings != [] ? self.pairStrings : [""], id: \.self){ element in
                if self.nilArray == true {
                    EventCardView(emoji: "😔", text: "Не могу получить информацию :(")
                }
                else if self.pairStrings != [] {
                    let pairJSON = JSON(parseJSON: element)
                    ScheduleCardView(pairType: pairJSON["type"].stringValue,
                                     pairTime: pairJSON["time"].stringValue,
                                     pairTitle: pairJSON["title"].stringValue,
                                     pairClassRoom: pairJSON["classroom"].stringValue,
                                     pairTeacher: pairJSON["teacher"].stringValue,
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

struct TeacherScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherScheduleView(teacher: "Мурлина.Владислава.Анатольевна")
    }
}
