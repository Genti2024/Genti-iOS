//
//  ThirdGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import SwiftUI

struct ThirdGeneratorView: View {
    @State var viewModel: ThirdGeneratorViewModel
    @Bindable var router: Router<MainRoute>
    var body: some View {
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                VStack(spacing: 0) {
                    headerView()
                    imageUploadView()
                    cautionScrollView()
                    completeButtonView()
                } //:VSTACK
            } //:ZSTACK
            .toolbar(.hidden, for: .navigationBar)
    }
    
    private func completeButtonView() -> some View {
        GeneratorNavigationButton(isActive: viewModel.facesIsEmpty, title: "사진 생성하기") {
            Task {
                do {
                    try await viewModel.generateImage()
                    router.routeTo(.requestCompleted)
                } catch(let error) {
                    print(error as! GentiError)
                }
            }
            
        }
        .padding(.bottom, 32)
    }
    
    private func headerView() -> some View {
        GeneratorHeaderView(router: router, step: 3, headerType: .backAndDismiss)
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
                LinearGradient(colors: [.backgroundWhite, .backgroundWhite.opacity(0)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 20)
                Spacer()
                LinearGradient(colors: [.backgroundWhite, .backgroundWhite.opacity(0)], startPoint: .bottom, endPoint: .top)
                    .frame(height: 20)
            }
        }
        .padding(.top, .height(ratio: 0.02))
        .padding(.bottom, 30)
    }
    
    private func imageUploadView() -> some View {
        VStack(spacing: 8) {
            Text("사진 생성에 이용할 얼굴 3장을 업로드해주세요")
                .pretendard(.normal)
                .foregroundStyle(.black)
                .frame(height: 22)
            
            if viewModel.facesIsEmpty {
                Image("AddImageIcon")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .frame(height: 116)
                    .frame(maxWidth: .infinity)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        router.routeTo(.imagePicker(limitCount: 3, viewModel: viewModel))
                    }
            } else {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("사진 수정하기")
                            .pretendard(.description)
                            .foregroundStyle(.gray4)
                        Image("ImageFix")
                            .frame(width: 19, height: 19)
                    } //:HSTACK
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        router.routeTo(.imagePicker(limitCount: 3, viewModel: viewModel))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.referenceImages) { imageAsset in
                            PHAssetImageView(asset: imageAsset.asset)
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

//#Preview {
//    ThirdGeneratorView(router: .init())
//}
