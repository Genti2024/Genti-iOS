//
//  GenerateCompleteView.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import SwiftUI

struct GenerateRequestCompleteView: View {
    @Bindable var router: Router<MainRoute>

    var body: some View {
        ZStack {
            
            Color.backgroundWhite
                .ignoresSafeArea()
            
            LinearGradient(gradient: Gradient(colors: [Color.gradientPurple1, Color.gentiPurple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                VStack(spacing: 30) {
                    Image("Genti_LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                        .padding(.top, 44)
                    
                    
                    Image("CompleteLabel")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 55)
                    
                    Image("Complete_charactor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 275)

                } //:VSTACK
                
                Text("예상 소요시간은 2시간입니다")
                    .pretendard(.normal)
                    .foregroundStyle(.black)
                    .padding(.top, 15)
                
                Text("미리 만들어놓은 컨셉에 얼굴만 바꾸는게 아니라\n’나만의 하나뿐인 사진’을 찍어드리기 위해  \n배경부터 의상, 구도까지 꼼꼼하게 준비하고 있어요")
                    .pretendard(.small)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 25)
                
                Spacer(minLength: 0)
                
                Button {
                    // Action
                    router.dismissSheet()
                } label: {
                    Text("피드로 돌아가기")
                        .pretendard(.headline1)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.gentiGreen)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .padding(.horizontal, 31)
                .padding(.bottom, .height(ratio: 0.03))
                .buttonStyle(.plain)
            } //:VSTACK
        } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    GenerateRequestCompleteView(router: .init())
}


