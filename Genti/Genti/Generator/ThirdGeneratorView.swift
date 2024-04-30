//
//  ThirdGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import SwiftUI

struct ThirdGeneratorView: View {
    
    @EnvironmentObject var viewModel: GeneratorViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                VStack(spacing: 0) {
                    GeneratorNavigationView()
                        .padding(.horizontal, 24)
                    
                    GeneratorHeaderView(step: 3)
                        .padding(.top, 10)
                    
                    imageUploadView()
                        .padding(.top, .height(ratio: 0.048))
                    
                    cautionScrollView()

                    nextButton()
                        .padding(.horizontal, 28)
                        .padding(.bottom, .height(ratio: 0.03))
                        .padding(.top, .height(ratio: 0.02))
                } //:VSTACK
            } //:ZSTACK
            .fullScreenCover(isPresented: $viewModel.showPhotoPicker) {
                PopupImagePickerView(imagePickerModel: ImagePickerViewModel(albumService: AlbumService(), limitCount: 3), pickerType: .faces)
            }
        }
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
                
                Spacer()
                    .frame(height: 8)

                ForEach(Caution.texts, id: \.self) { text in
                    BulletText(text: text)
                }
                
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
                    Text("만들고자 하는 사진과 같은 각도의 얼굴을 사용하면\n더욱 정확하게 만들어져요!")
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
            .padding(.vertical, 30)
        }
        .overlay {
            VStack {
                LinearGradient(colors: [.backgroundWhite, .backgroundWhite.opacity(0)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 30)
                Spacer()
                LinearGradient(colors: [.backgroundWhite, .backgroundWhite.opacity(0)], startPoint: .bottom, endPoint: .top)
                    .frame(height: 30)
            }
        }
    }
    
    private func imageUploadView() -> some View {
        VStack(spacing: 5) {
            Text("사진 생성에 이용할 얼굴 3장을 업로드해주세요")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            if viewModel.faceImagesIsEmpty {
                Image("AddImageIcon")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .padding((CGFloat.height(ratio: 0.14)-29)/2)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        viewModel.showPhotoPicker = true
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
                        viewModel.showPhotoPicker = true
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.faceImages) { imageAsset in
                            PHAssetImageView(from: imageAsset.asset)
                        }
                    } //:HSTACK
                } //:VSTACK
                .frame(height: .height(ratio: 0.14))
                .padding(.horizontal, 39)
            }
        } //:VSTACK
    }
    
    private func nextButton() -> some View {
        Button {
            // Action
        } label: {
            Text("다음으로")
                .pretendard(.headline1)
                .foregroundStyle(viewModel.descriptionIsEmpty ? .white : .black)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(viewModel.descriptionIsEmpty ? .green1 : .gray5)
                .clipShape(.rect(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.descriptionIsEmpty)
    }
}

#Preview {
    ThirdGeneratorView()
        .environmentObject(GeneratorViewModel())
}
