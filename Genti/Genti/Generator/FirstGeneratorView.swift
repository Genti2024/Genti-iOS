//
//  FirstGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI
import Combine

struct FirstGeneratorView: View {
    @EnvironmentObject var viewModel: GeneratorViewModel
    
    @Binding var generateFlow: [GeneratorFlow]
    
    private let randomDescription: [String] = [
        "프랑스 야경을 즐기는 모습을 그려주세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.1",
        "프랑스 야경을 즐기는 모습을 그려주세모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요. 항공점퍼를 입고 테라스요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.2",
        "프랑스 야경을 즐기는 모습을 그려. 항공점퍼를 입고주세요. 항공점퍼를 입고. 항공점퍼를 입고 테라스에 서 있는 모습이에요.3",
        "프랑스 야경을 즐기는 모습을 그려주모습을 그려주세요. 항공점퍼를 입고 테라스세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.4",
    ]
    
    @State private var currentIndex: Int = 0
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                VStack(spacing: 0) {
                    
                    GeneratorHeaderView(step: 1)
                        .padding(.top, 40)
                    
                    inpuTextView()
                        .padding(.top, 32)
                    
                    randomDescriptionView()
                    
                    
                    addImageView()
                        .padding(.top, 43)
                    
                    
                    Spacer()

                    GeneratorNavigationButton(isActive: viewModel.descriptionIsEmpty) {
                        self.generateFlow.append(.second)
                    }
                    .padding(.bottom, 32)
                } //:VSTACK
            } //:ZSTACK
        }
        .ignoresSafeArea(.keyboard)

 
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            isFocused = true
        }
        .focused($isFocused)
        .fullScreenCover(isPresented: $viewModel.showPhotoPickerWhenFirstView) {
            PopupImagePickerView(imagePickerModel: ImagePickerViewModel(limitCount: 1), pickerType: .reference)
                .environmentObject(viewModel)
            
        }
        .toolbar(.hidden, for: .navigationBar)
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
                            Text(randomDescription[currentIndex])
                                .pretendard(.description)
                                .foregroundStyle(.black)
                                .lineLimit(3)
                                .padding(12)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                
                Button {
                    // Action
                    let maxIndex = randomDescription.count-1
                    if currentIndex == maxIndex {
                        currentIndex = 0
                    } else {
                        currentIndex += 1
                    }
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
    }
    
    @ViewBuilder
    private func referenceImage() -> some View {
        if let referenceImage = viewModel.referenceImage?.asset {
            PHAssetImageView(asset: referenceImage)
                .frame(width: CGFloat.height(ratio: 0.13), height: CGFloat.height(ratio: 0.13))
                .overlay(alignment: .topTrailing) {
                    Image("ImageRemoveButton")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(4)
                        .background(.black.opacity(0.001))
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.removeReferenceImage()
                            }
                        }
                }
        } else {
            Image("AddImageIcon")
                .resizable()
                .frame(width: 29, height: 29)
                .padding((CGFloat.height(ratio: 0.13)-29)/2)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    viewModel.showPhotoPickerWhenFirstView = true
                }
        }
    }
    
    private func descriptionTextEditor() -> some View {
        ZStack {
            TextEditor(text: $viewModel.photoDescription)
                .limit(text: $viewModel.photoDescription, limit: 200)
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

#Preview {
    FirstGeneratorView(generateFlow: .constant([]))
        .environmentObject(GeneratorViewModel())
}
