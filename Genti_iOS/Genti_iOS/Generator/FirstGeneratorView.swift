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
    
    init(viewModel: FirstGeneratorViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                VStack(spacing: 0) {
                    headerView()
                    inpuTextView()
                    randomDescriptionView()
                    addImageView()
                    Spacer()
                    nextButtonView()
                } //:VSTACK
            } //:ZSTACK
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
    }
    
    private func nextButtonView() -> some View {
        GeneratorNavigationButton(isActive: viewModel.descriptionIsEmpty) {
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
        VStack {
            Text("이런 사진은 어때요?")
                .pretendard(.number)
                .foregroundStyle(.gentiGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 7) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .strokeBorder(.gentiGreen, style: .init(lineWidth: 1))
                    .frame(height: 68)
                    .shadow(color: .black.opacity(0.09), radius: 5)
                
                    .overlay {
                        Text(viewModel.state.currentRandomDescriptionExample)
                            .pretendard(.description)
                            .foregroundStyle(.black)
                            .lineLimit(3)
                            .padding(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                
                Button {
                    // Action
                    self.viewModel.sendAction(.randomButtonTap)
                } label: {
                    Image("Change")
                        .resizable()
                        .frame(width: 17, height: 17)
                        .padding(10)
                }
            } //:HSTACK
            
        }
        .padding(.horizontal, 29)
        .padding(.top, 10)
    }
    private func inpuTextView() -> some View {
        VStack(spacing: 0) {
            Text("만들고 싶은 사진을 설명해주세요✏️")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            descriptionTextEditor()
                .padding(.horizontal, 29)
                .padding(.top, 14)
            
        } //:VSTACK
        .padding(.top, 32)
    }
    private func addImageView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 3) {
                Text("참고사진이 있다면 추가해주세요")
                    .pretendard(.normal)
                    .foregroundStyle(.black)
                    .padding(.bottom, 5)
                
                Text("(선택)")
                    .pretendard(.description)
                    .foregroundStyle(.black)
            }
            
            
            referenceImage()
            
            Text("(참고사진은 최대 1장 업로드 할 수 있어요)")
                .pretendard(.description)
                .foregroundStyle(.gray3)
                .padding(.top, 5)
        } //:VSTACK
        .padding(.top, 43)
    }
    @ViewBuilder
    private func referenceImage() -> some View {
        if viewModel.state.referenceImages.count == 0 {
            Image("AddImageIcon")
                .resizable()
                .frame(width: 29, height: 29)
                .padding((CGFloat.height(ratio: 0.13)-29)/2)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    self.viewModel.sendAction(.addImageButtonTap)
                }
        } else {
            let referenceImage = viewModel.state.referenceImages[0].asset
            PHAssetImageView(viewModel: PHAssetImageViewModel(), asset: referenceImage)
                .frame(width: CGFloat.height(ratio: 0.13), height: CGFloat.height(ratio: 0.13))
                .overlay(alignment: .topTrailing) {
                    Image("ImageRemoveButton")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(4)
                        .background(.black.opacity(0.001))
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
            
            if viewModel.descriptionIsEmpty {
                Text("""
                    의상과 배경을 포함해서 설명해 주세요!  * 헤어스타일을 변경하는 기능은 준비 중이에요 * 너무 특정한 배경과 의상은 구현이 어려울 수 있어요 (반포 한강 공원, 나이키 티셔츠 등)
                    """)
                .withFont(font: .PretendardType.small.value, color: .gray7, minimumScaleFactor: 0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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

//#Preview {
//    FirstGeneratorView(router: .init())
//}
