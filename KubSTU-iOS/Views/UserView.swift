//
//  UserView.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 29.09.2022.
//

import SwiftUI
import SwiftyJSON


struct UserView: View {
    @State var groupSelectSheet: Bool = false
    @State var showLicense: Bool = false
    @State var showInfoApp: Bool = false
    @State var insertedGroup: String = ""
    @State var checkInserted: Bool = false
    @State var startViewCount = 0
    let defaults = UserDefaults.standard
    let api = Api()
    var body: some View {
        
        
//
//        VStack {
//            HStack {
//                Text("Группа")
//                Spacer()
//                Button
//                {
//                    self.groupSelectSheet.toggle()
//                } label: {
//                    Text((defaults.string(forKey: "user-group") != nil ? defaults.string(forKey: "user-group")! : "Нет группы!"))
//                }
//            }.padding(.horizontal, 50)
            
        
        NavigationView {
            Form {
                Section(header: Text("Группа")) {
                    HStack {
                        Text("Группа:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text((defaults.string(forKey: "user-group") != nil ? defaults.string(forKey: "user-group")! : "нет группы"))
                            .frame(alignment: .trailing)
                    }
                    Button {
                        self.groupSelectSheet.toggle()
                    } label: {
                        Text("Изменить")
                    }
                }
                
//                Section (header: Text("Разное")) {
//                    Picker("Стартовая страница", selection: $startViewCount) {
//                        Text("Новости")
//                            .tag(0)
//                        Text("Поиск")
//                            .tag(1)
//                        Text("Расписание")
//                            .tag(2)
//                    }
//                    .onChange(of: self.startViewCount) { value in
//                        self.defaults.set(self.startViewCount, forKey: "start-page")
//                    }
//                }
            
                

                
                Section (header: Text("Сброс")) {
                    Button {
                        self.insertedGroup = ""
                        self.defaults.set(nil, forKey: "user-group")
                        self.defaults.set(nil, forKey: "schedule")
                    } label: {
                        Text("Сбросить группу")
                            .foregroundColor(.red)
                    }
                    .disabled(false)
                    Button {
                        self.insertedGroup = ""
                        self.defaults.set(nil, forKey: "teachers-list")
                        self.defaults.set(nil, forKey: "user-group")
                        self.defaults.set(nil, forKey: "schedule")
                        self.defaults.set(nil, forKey: "all-groups")
                        self.defaults.set(nil, forKey: "latest-selected-teachers")
                    } label: {
                        Text("Сбросить все данные")
                            .foregroundColor(.red)
                    }
                    .disabled(false)
                }
                Section (header: Text("Информация")) {
                    Button {
                        self.showLicense.toggle()
                    } label: {
                        Text("Лицензия")
                    }
                    Button {
                        self.showInfoApp.toggle()
                    } label: {
                        Text("О приложении")
                    }
                    
                }
            }
            .navigationTitle("Настройки")
            
        }
        .sheet(isPresented: $showInfoApp, content: {
            VStack (spacing: 30) {
                HStack {
                    Button {
                        self.showInfoApp.toggle()
                    } label: {
                        Text("Закрыть").font(.headline).multilineTextAlignment(.trailing)
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                }.frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                
                VStack {
                    Image("logo-blue-trans-300x300")
                    
                        .resizable()
                        .padding(.all)
                    
                }                        .frame(width: 200, height: 200, alignment: .center)
                    .background(Resources.Colors.newsCard)
                    .cornerRadius(20)

                    .shadow(color: Color.black.opacity(0.5), radius: 5, y: 3)

                VStack (spacing: 15) {
                    Text("Приложение КубГТУ").font(.title3).bold().multilineTextAlignment(.center).lineLimit(2)
                    Text("Мобильное приложение для студентов и преподавателей Кубанского государственного технологического университета!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .lineLimit(5)
                    Text("Версия: 0.3.1").font(.footnote).foregroundColor(Color.gray.opacity(0.7))
                }
                .padding(.horizontal, 25)
                .padding(.bottom)
                Spacer()
                
            }
        })
        .sheet(isPresented: $showLicense, content: {
            ZStack () {
                VStack {
                    Spacer().frame(height: 60)
                    ScrollView  {
                        Text(String(data: NSDataAsset(name: "LICENSE")!.data, encoding: String.Encoding(rawValue: NSUTF8StringEncoding) )!)
                            .font(.custom("", size: 12)).padding(.horizontal, 6)
                    
                    }.padding(.bottom).padding(.horizontal, 6)
                        .edgesIgnoringSafeArea(.bottom)
                }
                VStack {
                    HStack {
                        Button {
                            self.showLicense.toggle()
                        } label: {
                            Text("Закрыть").font(.headline).multilineTextAlignment(.trailing)
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)
                    Spacer()
                }
            }
        })
        
            .sheet(isPresented: $groupSelectSheet) {
                NavigationView {
                    VStack (spacing: 25) {
                        
                        Form {
                            Section(header: Text("Шифр группы")) {
                                
                                TextField("Пример: 21-КБ-ПИ1", text: $insertedGroup)
                                    .autocorrectionDisabled(true)
                                    .onChange(of: insertedGroup) { value in
                                        let check: Bool = self.api.groupValidate(user_group: self.insertedGroup.uppercased())
                                        self.checkInserted = check
                                        if check == true {
                                            self.defaults.set(self.insertedGroup.uppercased(), forKey: "user-group")
                                            self.api.getNewSchedule()
                                        }
                                    }
                                Text(self.checkInserted ? "Нашел :>" : "Не могу найти :(")
                                    .font(.subheadline)
                                    .foregroundColor(self.checkInserted ? Color.green : Color.red)
                            }
                            
                            Button {
                                self.groupSelectSheet.toggle()
                            } label: {
                                Text("Готово")
                            }

                        }
                        
//                        BannerView().frame(width: UIScreen.main.bounds.width, height: 32, alignment: .center)

                    }.navigationTitle("Изменение группы")
                }
                    
                
            }
            .onAppear {
                self.insertedGroup = (self.defaults.string(forKey: "user-group") == nil ? "" : self.defaults.string(forKey: "user-group")!)
//                if self.defaults.integer(forKey: "start-page") != nil {
//                    self.startViewCount = self.defaults.integer(forKey: "start-page")
//                } else {
//                    self.startViewCount = 0
//                }
            }
        
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
