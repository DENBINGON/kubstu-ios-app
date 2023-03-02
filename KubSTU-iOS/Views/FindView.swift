//
//  FindView.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 29.09.2022.
//

import SwiftUI
import SwiftyJSON
struct FindView: View {
    @State private var findText: String = ""
    @State private var teachersArraySelected: [String] = []
    @State private var teachersArrayAll: Int = 0

    @FocusState private var focused: Bool
    
    private let defaults = UserDefaults.standard
    
    private func convertJSONTeacherToString(data: JSON) -> String {
        return data["surname"].stringValue + " " + data["name"].stringValue + " " + data["patronymic"].stringValue
    }
    
    private func getTeachersWithStr(line: String) -> [String] {
        let teachersList: [String] = self.defaults.stringArray(forKey: "teachers-list")!
        var response: [String] = []
        for teacher in teachersList {
            if self.convertJSONTeacherToString(data: JSON(parseJSON: teacher)).lowercased().contains(line.lowercased()) {
                response.append(teacher)
            }
        }
        return response
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form{
                    Section(header: Text("Преподаватель")){
                        
                        TextField(self.teachersArraySelected.count == 0 ? "Начни вводить..." : self.convertJSONTeacherToString(data: JSON(parseJSON: self.teachersArraySelected.choice())),
                                  text: $findText)
                        .onSubmit {
                            focused.toggle()
                        }
                        .keyboardType(.webSearch)
                        .focused($focused)
                        .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Text(String(teachersArraySelected.count) + " из " + String(self.teachersArrayAll))
                                        Spacer()
                                        Button {
                                            focused.toggle()
                                        } label: {
                                            Image(systemName: "chevron.down")
                                        }
                                    }
                                }
                            }
                        .onChange(of: self.findText) { value in
                            self.teachersArraySelected = value != "" ? self.getTeachersWithStr(line: value) : (self.defaults.stringArray(forKey: "latest-selected-teachers") != nil ? self.defaults.stringArray(forKey: "latest-selected-teachers")!.reversed() : [])
                        }
                        .autocorrectionDisabled(true)
                    }
                    Section(header: self.teachersArraySelected.count == 0 ? Text("") : self.findText == "" ? Text("История") : Text("Результаты поиска")) {
                        List {
                            ForEach(self.teachersArraySelected, id: \.self) { teacher in
                                NavigationLink(destination: TeacherScheduleView(teacher: JSON(parseJSON: teacher)))
                                {
                                        Text(self.convertJSONTeacherToString(data: JSON(parseJSON: teacher))).frame(alignment: .leading).foregroundColor(Color.primary)
                                }.accentColor(Resources.Colors.forgereground)
                            }
                        }
                    }
                }
//                BannerView().frame(width: UIScreen.main.bounds.width, height: 32, alignment: .center)

            }
            .navigationTitle("Поиск")
        }
        .onAppear {
            if self.defaults.stringArray(forKey: "latest-selected-teachers") != nil {
                self.teachersArraySelected = self.defaults.stringArray(forKey: "latest-selected-teachers")!.reversed()
            }
            if self.defaults.stringArray(forKey: "teachers-list") != nil {
                self.teachersArrayAll = self.defaults.stringArray(forKey: "teachers-list")!.count}
            else{
                self.teachersArrayAll = 0
            }
        }
    }
}


struct FindView_Previews: PreviewProvider {
    
    static var previews: some View {
        FindView(  )
    }
}
