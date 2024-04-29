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
                        GeneratorNavigationView()
                            .padding(.horizontal, 24)
                        
                        GeneratorHeaderView(step: 1)
                            .padding(.top, 10)
                    
                        inpuTextView()
                            .padding(.top, 32)
                        
                        addImageView()
                            .padding(.top, 44)

                        Spacer()
                            .frame(minHeight: 10, maxHeight: 80)
                        
                        nextButton()
                            .padding(.horizontal, 28)
     
                        Spacer()
                            .frame(minWidth: 10, maxHeight: 43)
                        
                        GeneratorExampleView()
                            .frame(height: 170)
                    } //:VSTACK
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)

            } //:ZSTACK
            .focused($isFocused)
            .onTapGesture {
                isFocused = false
            }
            .fullScreenCover(isPresented: $viewModel.showPhotoPicker) {
                PopupImagePickerView(imagePickerModel: ImagePickerViewModel(albumService: AlbumService(), limitCount: 1))
            }
        }

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
    
    private func addImageView() -> some View {
        VStack(spacing: 0) {
            Text("참고사진이 있다면 추가해주세요")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            if viewModel.referenceImage == nil {
                Image("AddImageIcon")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .padding(.top, 28)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 20)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        viewModel.showPhotoPicker = true
                    }
            } else {
                ImageView(from: viewModel.referenceImage!.asset)
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 20)
            }

            
            Text("(참고사진은 최대 1장 업로드 할 수 있어요)")
                .pretendard(.description)
                .foregroundStyle(.gray3)
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
                .pretendard(.description)
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
