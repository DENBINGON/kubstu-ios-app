//
//  NewsView.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 29.09.2022.
//

import SwiftUI

struct News: Equatable{
    var id = UUID()
    var title: String
    var description: String
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

struct NewsView: View{
    
    var news = [News(title: "Центр гуманитарной помощи КубГТУ #МЫВМЕСТЕ продолжает сбор вещей первой необходимости", description: "В Кубанском государственном технологическом университете открыт Центр гуманитарной помощи #МЫВМЕСТЕ. Он расположен по адресу: ул. Московская, 2, ауд. Ф-204 (дворец спорта «Политехник»)."), News(title: "Своих не бросаем!", description: "Сегодня, 23 сентября, обучающиеся, сотрудники и руководство Кубанского государственного технологического университета приняли участие в митинге в поддержку референдумов о вхождении в состав России Донецкой и Луганской народных республик и территорий Запорожской и Херсонской областей."), News(title: "Будущим студентам — о самом главном при поступлении в вуз", description: "26 сентября сотрудники отдела по работе с абитуриентами КубГТУ посетили ярмарку вакансий и учебных рабочих мест (г. Кореновск). Представители вуза рассказали абитуриентам и их родителям об институтах Кубанского политеха, основных правилах приема на 2023/24 учебный год и возможностях довузовской подготовки. Ярмарку также посетили руководители школ, сотрудники министерства образования, науки и молодежной политики Краснодарского края, муниципальных органов управления образованием высших и средних профессиональных образовательных организаций."), News(title: "В КубГТУ открыт новый сезон соревнований по баскетболу!", description: "27 сентября состоялась торжественная церемония открытия турнира по баскетболу за кубок ректора КубГТУ. С приветственным словом к спортсменам обратилось руководство вуза: и.о. ректора профессор Михаил Барышев и проректор по молодежной политике и социальным вопросам Мария Битарова."), News(title: "В КубГТУ состоятся соревнования по спортивному ориентированию", description: "29 сентября в 16:00 приглашаем принять участие в соревнованиях по спортивному ориентированию, которые пройдут на базе спортивного комплекса КубГТУ «Политехник». Регистрация участников по адресу: ул. Московская, 2, ауд. Ф-311. Контактное лицо — заведующий кафедрой физического воспитания и спорта Института фундаментальных наук Константин Малашенко. Важно! В день соревнований заявки принимаются с 15:30 до 16:00. Сбор участников — возле главного входа спортивного комплекса КубГТУ «Политехник»."), News(title:"Студентка КубГТУ — на Межрегиональной встрече выпускников Всероссийского конкурса", description: "20 — 22 сентября студентка гр. 19-НБ-ХТ1 Института нефти, газа и энергетики КубГТУ Екатерина Вычегжанина приняла участие в Межрегиональной встрече выпускников Всероссийского конкурса «Моя страна — моя Россия». Основная тема — социальное проникновение в волонтерство как ресурс развития территорий.")]
    
    var body: some View{
        VStack {
            NavigationView(){
                ScrollView(showsIndicators: false) {
                    VStack (spacing: 2) {
                        ForEach((news), id: \.self.id) { element in
                            NavigationLink(destination: DataView(data: element)) {CardView(title: element.title, description: element.description)
                            }
                        }
                        .navigationTitle("Новости")
                    }.padding(.vertical, 5)
                }
            }
        }
    }
}

struct DataView: View {
    var data: News
    var body: some View {
        VStack () {
            ScrollView(showsIndicators: false) {
                VStack(spacing:20){
                    Text(data.title)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(data.description)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
                Spacer()
            }.navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CardView: View {
    
    var title: String
    var description: String
    var image: Image = Image(systemName: "command")
    var body: some View {
        
        VStack {
            Spacer()
            HStack(spacing: 20) {
                self.image
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.accentColor.opacity(0.7), radius: 5)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(30)

                VStack(spacing:3) {
                    Text(self.title)
                        .bold()
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(self.description)
                        .font(.custom("", size: 13))
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                    
                }.foregroundColor(.primary)
                Spacer(minLength: 0)
            }
            .padding()
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 24, height: 150)
        .background(Resources.Colors.newsCard)
        .cornerRadius(30)
        .padding(.all, 3)
    }
}


struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}

