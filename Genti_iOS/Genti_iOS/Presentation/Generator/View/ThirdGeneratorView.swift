//
//  ThirdGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import SwiftUI

struct ThirdGeneratorView: View {
    @State var viewModel: ThirdGeneratorViewModel

    var body: some View {
            ZStack {
                // Background Color
                Color.geintiBackground
                    .ignoresSafeArea()
                // Content
                VStack(spacing: 0) {
                    Text("사진 생성에 사용할\n얼굴 사진 3장을 선택해주세요.")
                        .multilineTextAlignment(.center)
                        .pretendard(.title2_20_bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                        .frame(height: 16)
                    
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(.checkNew)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                            Text("정면을 포함하여 사진의 각도가 다양할수록 좋아요.")
                                .pretendard(.caption_12_regular)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        HStack(spacing: 4) {
                            Image(.checkNew)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                            Text("모자, 악세사리 등으로 얼굴이 가려진 사진은 안돼요.")
                                .pretendard(.caption_12_regular)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        HStack(spacing: 4) {
                            Image(.checkNew)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                            Text("얼굴 표정이 다양할 수록 더 실감나는 사진을 만들 수 있어요.")
                                .pretendard(.caption_12_regular)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        
                        Text("타인의 사진을 도용하면 서비스 이용이 정지되고,\n법적인 처벌을 받을 수 있습니다.")
                            .multilineTextAlignment(.center)
                            .pretendard(.caption_12_regular)
                            .foregroundStyle(.white.opacity(0.3))
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    if viewModel.state.referenceImages.isEmpty {
                        Text("이런 사진이 좋아요")
                            .pretendard(.body_14_bold)
                            .foregroundStyle(.gentiGreenNew)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        HStack(spacing: 6) {
                            ForEach(Caution.exampleImages, id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 96)
                                    .frame(height: 96)
                                    .clipped()
                            }
                        }
                        .frame(height: 96)
                        
                    } else {
                        HStack(spacing: 8) {
                            ForEach(viewModel.state.referenceImages) { imageAsset in
                                PHAssetImageView(viewModel: PHAssetImageViewModel(phassetImageRepository: PHAssetImageRepositoryImpl(service: PHAssetImageServiceImpl())), asset: imageAsset.asset)
                                    .frame(width: 118)
                                    .padding(1)
                                    .background(.gentiGreen)
                                    
                            }
                        } //:HSTACK
                        .frame(height: 118)
                    }
                    
                } //:VSTACK
                if viewModel.state.isLoading {
                    RequestWaitingView()
                }
                
                VStack {
                    Spacer()
                    
                    Text("사진 선택하기")
                        .pretendard(.subtitle2_16_bold)
                        .foregroundStyle(.black)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            self.viewModel.sendAction(.addImageButtonTap)
                        }
                    
                    GentiPrimaryButton(title: "사진 생성하기", isActive: viewModel.isActive) {
                        viewModel.sendAction(.nextButtonTap)
                    }
                }
                
            } //:ZSTACK
            .toolbar(.hidden, for: .navigationBar)
            .customAlert(alertType: $viewModel.state.showAlert)
    }
    
    private func completeButtonView() -> some View {
        GentiPrimaryButton(title: "사진 생성하기", isActive: viewModel.isActive) {
            viewModel.sendAction(.nextButtonTap)
        }
        .padding(.bottom, 32)
    }
    
    private func headerView() -> some View {
        GeneratorHeaderView(backButtonTapped: { viewModel.sendAction(.backButtonTap) },
                            xmarkTapped: { viewModel.sendAction(.xmarkTap) },
                            step: 3,
                            headerType: .backAndDismiss)
            .padding(.top, 40)
    }
    
    private func cautionScrollView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("💡")
                        .pretendard(.number)
                    Text("얼굴은 이런 사진을 사용해주세요!")
                        .pretendard(.number)
                        .foregroundStyle(.gray1)
                } //:HSTACK
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                
                Spacer()
                    .frame(height: 8)

                ForEach(Caution.texts, id: \.self) { text in
                    BulletText(text: text)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                    .frame(height: 18)
                
                VStack(spacing: 3) {
                    Text("<예시>")
                        .pretendard(.description)
                        .foregroundStyle(.gray1)
                    
                    HStack(spacing: 6) {
                        ForEach(Caution.exampleImages, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 84)
                        }
                    } //:HSTACK
                } //:VSTACK
                
                Spacer().frame(height: 15)
                
                VStack(spacing: 0) {
                    Text("💡")
                    Spacer()
                        .frame(height: 4)
                    Text("사진의 각도가 다양할수록 생성된 얼굴이 자연스러워져요!")
                        .pretendard(.number)
                        .foregroundStyle(.gray1)
                        .multilineTextAlignment(.center)
                    Spacer()
                        .frame(height: 15)
                    Text("<예시>")
                        .pretendard(.description)
                        .foregroundStyle(.gray1)

                    ForEach(Caution.beforeAfterImages, id: \.self) { images in
                        let beforeImage = images.before
                        let afterImage = images.after
                        HStack(spacing: 23) {
                            Image(beforeImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110)
                                .clipped()
                            
                            Image("Right_Shevron")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 9, height: 18)
                            
                            Image(afterImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110)
                                .clipped()
                        } //:HSTACK
                        .padding(.top, 15)
                        
                    }
                } //:VSTACK
                
            } //:VSTACK
            .padding(.vertical, 20)
        }
        .overlay {
            VStack {
                LinearGradient.backgroundWhite
                    .frame(height: 20)
                Spacer()
                LinearGradient.backgroundWhite
                    .frame(height: 20)
                    .rotationEffect(.degrees(180))
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
    
    private func imageUploadView() -> some View {
        VStack(spacing: 8) {
            Text("사진 생성에 이용할 얼굴 3장을 업로드해주세요")
                .pretendard(.normal)
                .foregroundStyle(.black)
                .frame(height: 22)
            
            if viewModel.state.referenceImages.isEmpty {
                Image("AddImageIcon")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .frame(height: 116)
                    .frame(maxWidth: .infinity)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        viewModel.sendAction(.addImageButtonTap)
                    }
            } else {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("사진 다시 선택하기")
                            .pretendard(.description)
                            .foregroundStyle(.gray4)
                        Image("ImageFix")
                            .frame(width: 19, height: 19)
                    } //:HSTACK
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        viewModel.sendAction(.reChoiceButtonTap)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.state.referenceImages) { imageAsset in
                            PHAssetImageView(viewModel: PHAssetImageViewModel(phassetImageRepository: PHAssetImageRepositoryImpl(service: PHAssetImageServiceImpl())), asset: imageAsset.asset)
                        }
                    } //:HSTACK
                } //:VSTACK
                .padding(.horizontal, 39)
                .frame(height: 116)
            }
        } //:VSTACK
        .padding(.top, 40)
    }
}

#Preview {
    ThirdGeneratorView(viewModel: ThirdGeneratorViewModel(imageGenerateUseCase: ImageGenerateUseCaseImpl(generateRepository: ImageGenerateRepositoryImpl(requsetService: RequestServiceImpl(), imageDataTransferService: ImageDataTransferServiceImpl(), uploadService: UploadServiceImpl())), requestImageData: RequestImageData(), router: .init()))
}
