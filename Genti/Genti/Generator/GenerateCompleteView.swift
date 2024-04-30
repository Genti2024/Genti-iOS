//
//  GenerateCompleteView.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import SwiftUI

struct GenerateCompleteView: View {
    
    @EnvironmentObject var viewModel: GeneratorViewModel
    var onXmarkPressed: (() -> Void)? = nil
    var userName: String = "i_am_GenTi"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundWhite
                    .ignoresSafeArea()
                
                
                LinearGradient(gradient: Gradient(colors: [Color.purple0, Color.gentiPurple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                // Content
                VStack(spacing: 0) {
                    VStack(spacing: 30) {
                        Image("Genti_LOGO")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                            .padding(.top, 44)
                        
                        
                        VStack {
                            HStack(alignment: .bottom, spacing: 5) {
                                Text("@\(userName)")
                                    .foregroundStyle(.gentiGreen)
                                    .pretendard(.headline1)
                                
                                Text("님의")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(.gentiGreen)
                            } //:HSTACK
                            
                            Text("사진을 찍고 있어요!")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.gentiGreen)
                        }
                        
                        Image("Complete_character")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 275)

                    } //:VSTACK
                    
                    Text("예상 소요시간은 4시간입니다")
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
                        onXmarkPressed?()
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
                    .padding(.bottom, 25)
                    .buttonStyle(.plain)
                } //:VSTACK
            } //:ZSTACK
            .onAppear {
                print("1. 디스크립션 : \(viewModel.photoDescription)")
                print("2. 참고사진 : \(String(describing: viewModel.referenceImage?.asset))")
                print("3. 앵글 : \(viewModel.selectedAngle!)")
                print("4. 프레임 : \(viewModel.selectedFrame!)")
                print("5. 얼굴사진 : \(viewModel.faceImages.map{$0.asset})")
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    GenerateCompleteView()
}


