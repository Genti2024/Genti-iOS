//
//  FirstGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI
import Combine

struct FirstGeneratorView: View {
    @State var viewModel: FirstGeneratorViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                headerView()
                inpuTextView()
                randomDescriptionView()
                addImageView()
                Spacer()
                nextButtonView()
            } //:VSTACK
            .background {
                Color.backgroundWhite
                    .ignoresSafeArea()
            }
        }
        .ignoresSafeArea(.keyboard)
        .focused($isFocused)
        .toolbar(.hidden, for: .navigationBar)
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            isFocused = true
            self.viewModel.sendAction(.viewWillAppear)
        }
        .customAlert(alertType: $viewModel.state.showAlert)
    }
    
    private func nextButtonView() -> some View {
        GentiPrimaryButton(title: "다음으로", isActive: viewModel.isActive) {
            self.viewModel.sendAction(.nextButtonTap)
        }
        .padding(.bottom, 32)
    }
    private func headerView() -> some View {
        GeneratorHeaderView(
            xmarkTapped: { self.viewModel.sendAction(.xmarkTap) },
            step: 1,
            headerType: .back)
            .padding(.top, 40)
    }
    private func randomDescriptionView() -> some View {
        VStack(spacing: 0) {
            Text("이런 사진은 어때요?")
                .pretendard(.number)
                .foregroundStyle(.gentiGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
            
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .strokeBorder(.gentiGreen, style: .init(lineWidth: 1))
                    .frame(height: 68)
                    .shadow(type: .strong)
                
                    .overlay {
                        Text(viewModel.state.currentRandomDescriptionExample)
                            .pretendard(.description)
                            .foregroundStyle(.black)
                            .lineLimit(3)
                            .padding(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }

                Image("Change")
                    .resizable()
                    .frame(width: 17, height: 17)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .padding(.leading, 10)
                    .background(.black.opacity(0.001))
                    .asButton {
                        self.viewModel.sendAction(.randomButtonTap)
                    }
            } //:HSTACK
            
        }
        .padding(.horizontal, 29)
        .padding(.top, 25)
    }
    private func inpuTextView() -> some View {
        VStack(spacing: 2) {
            Text("만들고 싶은 사진을 설명해주세요✏️")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            Text("성적이거나 폭력적인 사진은 만들어지지 않아요")
                .pretendard(.description)
                .foregroundStyle(.gray3)
            
            descriptionTextEditor()
                .padding(.horizontal, 29)
                .padding(.top, 13)
            
        } //:VSTACK
        .padding(.top, UIScreen.isWiderThan375pt ? 32 : 20)
    }
    private func addImageView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 3) {
                Text("참고할 구도의 사진이 있다면 추가해주세요")
                    .pretendard(.normal)
                    .foregroundStyle(.black)
                    .padding(.bottom, 5)
                
                Text("(선택)")
                    .pretendard(.description)
                    .foregroundStyle(.black)
            }
            
            
            referenceImage()
                .frame(width: UIScreen.isWiderThan375pt ? 138 : 100, height: UIScreen.isWiderThan375pt ? 138 : 100)
            
            Text("(참고사진은 최대 1장 업로드 할 수 있어요)")
                .pretendard(.description)
                .foregroundStyle(.gray3)
                .padding(.top, 5)
        } //:VSTACK
        .padding(.top, UIScreen.isWiderThan375pt ? 43 : 20)
    }
    @ViewBuilder
    private func referenceImage() -> some View {
        if viewModel.state.referenceImages.count == 0 {
            Image("AddImageIcon")
                .resizable()
                .frame(width: 29, height: 29)
                .padding(12)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    self.viewModel.sendAction(.addImageButtonTap)
                }
        } else {
            let referenceImage = viewModel.state.referenceImages[0].asset
            PHAssetImageView(viewModel: PHAssetImageViewModel(phassetImageRepository: PHAssetImageRepositoryImpl(service: PHAssetImageServiceImpl())), asset: referenceImage)
                .overlay(alignment: .topTrailing) {
                    Image("ImageRemoveButton")
                        .resizable()
                        .frame(width: 11, height: 11)
                        .padding(4)
                        .background(.black)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.sendAction(.removeButtonTap)
                            }
                        }
                }
        }
    }
    private func descriptionTextEditor() -> some View {
        ZStack {
            TextEditor(text: Binding(
                 get: { viewModel.state.photoDescription },
                 set: { viewModel.sendAction(.inputDescription($0)) }
             ))
                .limit(text: $viewModel.state.photoDescription, limit: 200)
                .pretendard(.number)
                .foregroundStyle(.black)
                .scrollContentBackground(.hidden)
                .background(.gray6)
                .padding(.horizontal, 8)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray6)
                        .stroke(.gray5, lineWidth: 1)
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            if viewModel.state.photoDescription.isEmpty {
                Text("""
                    의상과 배경을 포함해서 설명해 주세요!  * 헤어스타일을 변경하는 기능은 준비 중이에요 * 너무 특정한 배경과 의상은 구현이 어려울 수 있어요 (반포 한강 공원, 나이키 티셔츠 등)
                    """)
                .withFont(font: .PretendardType.small.value, color: .gray7, minimumScaleFactor: 0.5)
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .onTapGesture {
                    isFocused = true
                }
            }
        }
        .frame(height: 112)
    }
}

#Preview {
    FirstGeneratorView(viewModel: FirstGeneratorViewModel(router: .init()))
}
