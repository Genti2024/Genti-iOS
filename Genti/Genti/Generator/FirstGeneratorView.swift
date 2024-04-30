//
//  FirstGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI
import Combine

struct FirstGeneratorView: View {
    @StateObject var viewModel: GeneratorViewModel = GeneratorViewModel()
    @FocusState var isFocused: Bool
    
    var onXmarkPressed: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                GeometryReader { _ in
                    VStack(spacing: 0) {
                        GeneratorNavigationView(onXmarkPressed: onXmarkPressed)
                            .padding(.horizontal, 24)
                        
                        GeneratorHeaderView(step: 1)
                            .padding(.top, 10)
                    
                        inpuTextView()
                            .padding(.top, 32)
                        
                        addImageView()
                            .padding(.top, .height(ratio: 0.05))

                        Spacer(minLength: 0)
                        
                        nextButton()
                            .padding(.horizontal, 28)
    
                        
                        GeneratorExampleView()
                            .frame(maxHeight: .height(ratio: 0.21))
                            .padding(.top, .height(ratio: 0.05))
                    } //:VSTACK
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
            } //:ZSTACK
            .onTapGesture {
                isFocused = false
            }
            .focused($isFocused)
            .fullScreenCover(isPresented: $viewModel.showPhotoPickerWhenFirstView) {
                PopupImagePickerView(imagePickerModel: ImagePickerViewModel(albumService: AlbumService(), limitCount: 1), pickerType: .reference)

            }
        }
        .environmentObject(viewModel)
    }
    
    private func nextButton() -> some View {
        NavigationLink {
            SecondGeneratorView(onXmarkPressed: onXmarkPressed)
        } label: {
            Text("다음으로")
                .pretendard(.headline1)
                .foregroundStyle(viewModel.descriptionIsEmpty ? .white : .black)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(viewModel.descriptionIsEmpty ? .green1 : .gray5)
                .clipShape(.rect(cornerRadius: 10))
        }
        .disabled(!viewModel.descriptionIsEmpty)
    }
    
    private func addImageView() -> some View {
        VStack(spacing: 0) {
            Text("참고사진이 있다면 추가해주세요")
                .pretendard(.normal)
                .foregroundStyle(.black)
                .padding(.bottom, 5)
            
            if viewModel.referenceImage == nil {
                Image("AddImageIcon")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .padding((CGFloat.height(ratio: 0.13)-29)/2)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        viewModel.showPhotoPickerWhenFirstView = true
                    }
            } else {
                PHAssetImageView(from: viewModel.referenceImage!.asset)
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
            }
            
            Text("(참고사진은 최대 1장 업로드 할 수 있어요)")
                .pretendard(.description)
                .foregroundStyle(.gray3)
                .padding(.top, 5)
        } //:VSTACK
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
    
    private func descriptionTextEditor() -> some View {
        ZStack {
            TextEditor(text: viewModel.textEditorLimit)
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
                .onAppear {
                    isFocused = true
                }

            if !viewModel.descriptionIsEmpty {
                Text("ex) 잔디밭에 앉아서 과잠을 입고 막걸리를 먹는 모습을 만들어줘\n\n* 구체적인 지명을 지정하는 것은 불가능해요!")
                .pretendard(.small)
                .foregroundStyle(.gray7)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .onTapGesture {
                    isFocused = true
                }
            }
        }
        .frame(height: 94)
    }
}

#Preview {
    FirstGeneratorView()
        .environmentObject(GeneratorViewModel())
}
