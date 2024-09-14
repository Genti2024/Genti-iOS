//
//  OpenChatInfoView.swift
//  Genti_iOS
//
//  Created by uiskim on 9/13/24.
//

import SwiftUI

struct OpenChatInfoView: View {
    var router: Router<MainRoute>
    let openChatUrl: String
    let numberOfPeople: Int
    @State var disagree: Bool = false
    let userdefaultsRepository = UserDefaultsRepositoryImpl()
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Image(.xmarkGray)
                    .frame(width: 24, height: 24)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        self.userdefaultsRepository.setOpenChatAgreement(isAgree: !disagree)
                        self.router.dismissSheet()
                    }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal, 16)
            
            Text("내가 만든 특별한 사진,")
                .pretendard(.openChatHeadline)
                .foregroundStyle(.gentiGreen)
            Text("다른 사람에게 보여주고 싶다면?")
                .pretendard(.openChatHeadline)
                .foregroundStyle(.black)
            
            Spacer()
                .frame(height: 16)
            
            Text("젠티 사진 공유방에서 사진을 자랑하고\n다른 사람의 사진도 구경해보세요!")
                .pretendard(.openChatSubtitle)
                .foregroundStyle(.gray3)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Image(.openChat)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.isWiderThan375pt ? 390 : 290)
                .padding(.horizontal, 40)
            
            Spacer()
            
            HStack(spacing: 0) {
                Text("지금 ")
                    .foregroundStyle(.gray3)
                    .pretendard(.openChatDescription)
                Text("\(numberOfPeople)명 이상")
                    .foregroundStyle(.gentiGreen)
                    .pretendard(.openChatDescription)
                Text("이 나만의 하나뿐인 사진을 자랑하고 있어요!")
                    .foregroundStyle(.gray3)
                    .pretendard(.openChatDescription)
            }
            
            Spacer()
            
            Text("사진 공유방 참여하기")
                .pretendard(.openChatTitle1)
                .foregroundStyle(.black)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(.green1)
                .cornerRadius(10, corners: .allCorners)
                .padding(.horizontal, 16)
                .onTapGesture {
                    if let url = URL(string: openChatUrl) {
                        UIApplication.shared.open(url, options: [:], completionHandler: {_ in 
                            self.router.dismissSheet()
                        })
                    }
                    
                }
            
            Spacer()
                .frame(height: 24)
            
            HStack(spacing: 10) {
                Image(disagree ? .selected : .unselected)
                    .frame(width: 24, height: 24)
                
                Text("이 페이지 다시 보지 않기")
                    .foregroundStyle(disagree ? .black : .gray3)
                    .pretendard(.openChatTitle2)
            }
            .frame(height: 24)
            .background(.black.opacity(0.001))
            .onTapGesture {
                self.disagree.toggle()
            }
            
            Spacer()
                .frame(height: UIScreen.isWiderThan375pt ? 8 : 16)
        }
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
}

#Preview {
    OpenChatInfoView(router: .init(), openChatUrl: "", numberOfPeople: 2)
}
