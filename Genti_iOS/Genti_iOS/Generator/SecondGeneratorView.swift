//
//  SecondGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

import PopupView

struct SecondGeneratorView: View {
    @State var viewModel: SecondGeneratorViewModel
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            VStack(spacing: 0) {
                headerView()
                selectViews()
                Spacer()
                nextButtonView()
            } //:VSTACK
        } //:ZSTACK
        .addCustomPopup(isPresented: $viewModel.state.showOnboarding, popupType: .selectOnboarding)
        .onAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
        .toolbar(.hidden, for: .navigationBar)

    }
    
    private func nextButtonView() -> some View {
        GeneratorNavigationButton(isActive: viewModel.angleOrFrameOrRatioIsEmpty) {
            viewModel.sendAction(.nextButtonTap)
        }
        .padding(.bottom, 32)
    }
    
    private func selectViews() -> some View {
        VStack(spacing: 12) {
            ratioSelectView()
            angleSelectView()
            frameSelectView()
        } //:VSTACK
        .padding(.horizontal, 16)
        .padding(.top, 19)
    }
    
    private func headerView() -> some View {
        GeneratorHeaderView(backButtonTapped: { viewModel.sendAction(.backButtonTap) },
                            xmarkTapped: { viewModel.sendAction(.xmarkTap) },
                            step: 2,
                            headerType: .backAndDismiss)
            .padding(.top, 40)
    }
    
    private func ratioSelectView() -> some View {
        VStack(spacing: 8) {
            Text("사진의 비율을을 선택해주세요📷")
                .pretendard(.normal)
                .foregroundStyle(.black)
                .frame(height: 22)
            
            VStack(spacing: 5) {
                HStack(spacing: 9) {
                    ForEach(PhotoRatio.selections, id: \.self) { ratio in
                        Image(ratio.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: (UIScreen.main.bounds.width-32-16)/3)
                            .frame(height: (UIScreen.main.bounds.width-32-16)/3)
                            .overlay {
                                if viewModel.state.selectedRatio == ratio {
                                    Rectangle()
                                        .fill(.black.opacity(0.5))
                                        .strokeBorder(.green1, style: .init(lineWidth:2))
                                        .overlay {
                                            Text(ratio.description)
                                                .pretendard(.small)
                                                .foregroundStyle(.gentiGreen)
                                                .multilineTextAlignment(.center)
                                        }
                                }

                            }
                            .onTapGesture {
                                viewModel.sendAction(.ratioTap(ratio))
                            }
                    }
                } //:HSTACK
            } //:VSTACK

        } //:VSTACK
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func angleSelectView() -> some View {
        VStack(spacing: 0) {
            Text("카메라 앵글을 선택해주세요📷")
                .foregroundStyle(.black)
                .pretendard(.normal)
            
            VStack(spacing: 5) {
                HStack(spacing: 4) {
                    Text("앵글은 자유롭게 맡길래요")
                        .pretendard(.description)
                        .foregroundStyle(viewModel.state.selectedAngle == .any ? .green1 : .gray3)
                    Image(viewModel.state.selectedAngle == .any ? PhotoAngle.freeSelectedImage : PhotoAngle.any.image)
                } //:HSTACK
                .background(.black.opacity(0.001))
                .onTapGesture {
                    viewModel.sendAction(.angleTap(.any))
                }
                
                HStack(spacing: 9) {
                    ForEach(PhotoAngle.selections, id: \.self) { angle in
                        Image(angle.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if viewModel.state.selectedAngle == angle {
                                    Rectangle()
                                        .fill(.black.opacity(0.5))
                                        .strokeBorder(.green1, style: .init(lineWidth:2))
                                        .overlay {
                                            Text(angle.description)
                                                .pretendard(.small)
                                                .foregroundStyle(.gentiGreen)
                                                .multilineTextAlignment(.center)
                                        }
                                }

                            }
                            .onTapGesture {
                                viewModel.sendAction(.angleTap(angle))
                            }
                    }
                } //:HSTACK
            } //:VSTACK
        } //:VSTACK
    }
    
    private func frameSelectView() -> some View {
        VStack(spacing: 0) {
            Text("원하는 프레임을 선택해주세요📷")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            VStack(spacing: 5) {
                
                HStack(spacing: 4) {
                    Text("프레임은 자유롭게 맡길래요")
                        .pretendard(.description)
                        .foregroundStyle(viewModel.state.selectedFrame == .any ? .green1 : .gray3)
                    Image(viewModel.state.selectedFrame == .any ? PhotoFrame.freeSelectedImage : PhotoAngle.any.image)
                } //:HSTACK
                .background(.black.opacity(0.001))
                .onTapGesture {
                    viewModel.sendAction(.frameTap(.any))
                }
                
                HStack(spacing: 9) {
                    ForEach(PhotoFrame.selections, id: \.self) { frame in
                        Image(frame.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if viewModel.state.selectedFrame == frame {
                                    Rectangle()
                                        .fill(.black.opacity(0.5))
                                        .strokeBorder(.green1, style: .init(lineWidth:2))
                                        .overlay {
                                            Text(frame.description)
                                                .pretendard(.small)
                                                .foregroundStyle(.gentiGreen)
                                                .multilineTextAlignment(.center)
                                        }
                                }

                            }
                            .onTapGesture {
                                viewModel.sendAction(.frameTap(frame))
                            }
                    }
                } //:HSTACK

            } //:VSTACK
        } //:VSTACK
    }
}

#Preview {
    SecondGeneratorView(viewModel: SecondGeneratorViewModel(requestImageData: .init(), router: .init(), userdefaultRepository: UserDefaultsRepositoryImpl()))
}


