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
    
    private func getDailyJSON() -> JSON {
        let weekJSON: JSON = self.json[self.getWeekEven()]["schedule"]
        let dayTitle = self.weekDays[self.getDayNumber()]
        for dayCounter in 0..<7 {
            if dayTitle == weekJSON[dayCounter]["day"].stringValue{
                return weekJSON[dayCounter]
            }
        }
        return self.json
    }
    
    private func getWeekEven() -> Int {
        let Calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let Components = Calendar.components(.weekOfYear, from: self.date)
        return (Components.weekOfYear! - 1) % 2 == 1 ? 0 : 1
    }
    private func getDayNumber() -> Int {
        let Calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let Components = Calendar.components(.weekday, from: self.date)
        return Components.weekday! - 1
        
    }
    
    var body: some View {
        NavigationView() {
            ScrollView(showsIndicators: false) {
                VStack (spacing:10){
                    VStack (spacing: 5) {
                        ZStack {
                            Text(String(self.weekDays[self.getDayNumber()]) + " " + self.setDateString() + ", \(self.weekEven == 0 ? "нечётная" : "четная") неделя")
                                .font(.headline)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }.padding(.all, 5)
                        ForEach(self.pairStrings != [] ? self.pairStrings : [""], id: \.self){ element in
                            if self.nilDefaults == true {
                                VStack (spacing:50){
                                    Text("😔")
                                        .font(.custom("", size: 80) )
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text("Не могу получить информацию :(")
                                        .font(.title2)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .foregroundColor(Color.primary)
                                }
                                .frame(width: 300, height: 300, alignment: .center)
                                .background(Color("NewsCardColor"))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                            }
                            else if self.pairStrings != [] {
                                let pairJSON = JSON(parseJSON: element)
                                ScheduleCardView(pairType: pairJSON["type"].stringValue,
                                                 pairTime: pairJSON["time"].stringValue,
                                                 pairTitle: pairJSON["title"].stringValue,
                                                 pairClassRoom: pairJSON["classroom"].stringValue,
                                                 pairTeacher: pairJSON["teacher"].stringValue,
                                                 pairCount: String(1),
                                                 pairColor: Color.green,
                                                 pairPeriod: pairJSON["period"].stringValue)
                                
                            }
                            else {
                                VStack (spacing:50){
                                    Text("🥳")
                                        .font(.custom("", size: 80) )
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text("Сегодня пар нет ;)")
                                        .font(.title2)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .foregroundColor(Color.primary)
                                }
                                .frame(width: 300, height: 300, alignment: .center)
                                .background(Color("NewsCardColor"))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                            }
                        }
                    }
                }
                Spacer()
                
                    .padding()
                    .navigationTitle("")
                    .toolbar(content: {
                        
                        HStack () {
                            DatePicker("", selection: $date, displayedComponents: [.date])
                                .datePickerStyle(.compact)
                                .onChange(of: date, perform: { v in
                                    self.weekEven = self.getWeekEven()
                                    self.dayNumber = self.getDayNumber()
                                    self.dateString = setDateString()
                                    self.pairStrings = []
                                    for obj in self.getDailyJSON()["pairs"].arrayValue{
                                        self.pairStrings.append(obj.description)
                                    }
                                })
                            HStack (spacing: 20) {
                                Spacer()
                                ForEach ( [-86400, 86400], id: \.self ) { element in
                                    Button  {
                                        self.date.addTimeInterval(TimeInterval(element))
                                    } label: {
                                        HStack{
                                            Image(systemName: element > 0 ? "arrow.right" : "arrow.left")
                                        }
                                        .frame(width: 25, height: 20, alignment: .center)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .shadow(radius: 1)
                                        .scaleEffect(1.5)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                        .padding(.bottom, 5)
                    })
                    .navigationBarTitleDisplayMode(.inline)
                
            }
            
            
            
        }.onAppear(perform: {
            self.weekEven = self.getWeekEven()
            self.dayNumber = self.getDayNumber()
            if self.defaults.string(forKey: "schedule") != nil {
                self.json = JSON(parseJSON: self.defaults.string(forKey: "schedule")!)
                nilDefaults = false
            }
            else {
                nilDefaults = true
            }
            self.dateString = setDateString()
            self.pairStrings = []
            for obj in self.getDailyJSON()["pairs"].arrayValue{
                self.pairStrings.append(obj.description)
            }
        })
    }
}


struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
