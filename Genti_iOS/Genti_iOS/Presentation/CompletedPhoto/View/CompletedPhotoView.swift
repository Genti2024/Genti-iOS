//
//  PhotoCompleteView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

import PopupView
import SDWebImageSwiftUI
import Lottie

struct CompletedPhotoView: View {

    @State var viewModel: CompletedPhotoViewModel

    var body: some View {
        VStack {
            Image(.closeNew)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .frame(height: 40)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
                .onTapGesture {
                    self.viewModel.sendAction(.goToMainButtonTap)
                }
            Spacer()
                .frame(height: viewModel.photoInfo.imageRatio == .sero ? 0 : 63)
            
            VStack(spacing: 8) {
                Text("하나뿐인 나만의 사진 완성")
                    .foregroundStyle(.white)
                    .pretendard(.title1_24_bold)
                
                Text("마이페이지에서 사진을 확인 할 수 있습니다.")
                    .pretendard(.body_14_medium)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
                .frame(height: viewModel.photoInfo.imageRatio == .sero ? 32 : 64)
            
            WebImage(url: URL(string: viewModel.state.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16, corners: .allCorners)
                    .overlay(alignment: .bottomTrailing) {
                        Image(.downloadNew)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .padding(.bottom, 8)
                            .padding(.trailing, 8)
                            .onTapGesture {
                                self.viewModel.sendAction(.downloadButtonTap)
                            }
                    }
                    .padding(.horizontal, viewModel.photoInfo.imageRatio == .sero ? 45 : 16)
                    .onTapGesture {
                        self.viewModel.sendAction(.imageTap)
                    }

            } placeholder: {
                LottieView(type: .imageLoading)
                    .looping()
                    .frame(width: 80, height: 80)
            }
            .onSuccess { image, _, _ in
                self.viewModel.sendAction(.imageLoad(image))
            }
            
            Spacer()

            
            Image(.tooltipNew)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 47)
            
            ShareLink(item: viewModel.getImage, preview: .init("내 사진", image: viewModel.getImage)) {
                GentiPrimaryButton(title: "공유하기", isActive: true) {}
            }
            .disabled(viewModel.disabled)
            .onTapGesture {
                self.viewModel.sendAction(.shareButtonTap)
            }
            
            
            Text("사진이 잘못 나왔나요?")
                .pretendard(.body_14_bold)
                .foregroundStyle(.white.opacity(0.6))
                .safeAreaPadding(.bottom, 8)
                .onTapGesture {
                    self.viewModel.sendAction(.reportButtonTap)
                }
            

        }
        .background(
            WebImage(url: URL(string: viewModel.state.imageUrl))
                .overlay {
                    BlurView(style: .systemThinMaterialDark)
                        .ignoresSafeArea()
                        .overlay {
                            LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom)
                        }
                }
        )
//        GeometryReader { geometry in
//            
//            VStack(spacing: 0) {
//                if viewModel.photoInfo.imageRatio == .sero {
//                    SeroImageContentView(viewModel: viewModel)
//                } else {
//                    GaroImageContentView(viewModel: viewModel)
//                }
//                
//                Spacer()
//                
//                ShareLink(item: viewModel.getImage, preview: .init("내 사진", image: viewModel.getImage)) {
//                    Text("공유하기")
//                        .shareStyle()
//                }
//                .disabled(viewModel.disabled)
//                .onTapGesture {
//                    self.viewModel.sendAction(.shareButtonTap)
//                }
//                
//                Spacer()
//                    .frame(height: 18)
//                
//                Text("메인으로 이동하기")
//                    .pretendard(.small)
//                    .foregroundStyle(.gray3)
//                    .frame(maxWidth: .infinity)
//                    .background(.black.opacity(0.001))
//                    .onTapGesture {
//                        self.viewModel.sendAction(.goToMainButtonTap)
//                    }
//                
//                Spacer()
//                
//                
//                Text("혹시 만들려고 했던 사진과 전혀 다른 사진이 나왔나요?")
//                    .pretendard(.small)
//                    .foregroundStyle(.error)
//                    .underline()
//                    .onTapGesture {
//                        self.viewModel.sendAction(.reportButtonTap)
//                    }
//                Spacer()
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height)
//            .background {
//                Color.backgroundWhite
//                    .ignoresSafeArea()
//            }
//            .customToast(toastType: $viewModel.state.showToast)
//            .overlay(alignment: .center) {
//                if viewModel.state.isLoading {
//                    LoadingView()
//                }
//            }
//        }
        .onAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
        .addCustomPopup(isPresented: $viewModel.state.showRatingView, popupType: .rating(viewModel.photoInfo))
        .onReceive(NotificationCenter.default.publisher(for: .init("ratingCompleted"))) { _ in
            self.viewModel.sendAction(.ratingActionIsDone)
        }
//        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}

#Preview {
    CompletedPhotoView(viewModel: CompletedPhotoViewModel(photoInfo: .init(), router: .init(), completedPhotoUseCase: CompletedPhotoUseCaseImpl(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), userRepository: UserRepositoryImpl(requestService: RequestServiceImpl()))))
}
