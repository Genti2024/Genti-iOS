//
//  FirstGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI
import Combine

struct ExampleEntity {
    var imageUrl: String
    var description: String
}

struct FirstGeneratorView: View {
    @State var viewModel: FirstGeneratorViewModel
    @FocusState var isFocused: Bool
    @State private var currentPage: Int = 0
    @State private var examples: [ExampleEntity] = [
        .init(imageUrl: Constants.randomImage, description: "11111"),
        .init(imageUrl: Constants.randomImage, description: "22222"),
        .init(imageUrl: Constants.randomImage, description: "3333333"),
        .init(imageUrl: Constants.randomImage, description: "4444444")
    ]
    var body: some View {
        VStack(spacing: 0) {
            Text("어떤 사진을 만들고 싶나요?")
                .pretendard(.title2_20_bold)
                .foregroundStyle(.white)
            
            Spacer()
                .frame(height: 16)
            
            VStack {
                HStack(spacing: 4) {
                    Image(.checkNew)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                    Text("AI가 이해하지 못하는 장소나 의상은 생성이 어려울 수 있어요.")
                        .pretendard(.caption_12_regular)
                        .foregroundStyle(.white.opacity(0.6))
                }
                HStack(spacing: 4) {
                    Image(.checkNew)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                    Text("성적이거나 폭력적인 사진은 생성되지 않아요.")
                        .pretendard(.caption_12_regular)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            
            Spacer()
                .frame(height: 32)
            
            Text("이런 사진은 어때요?")
                .pretendard(.body_14_bold)
                .foregroundStyle(.gentiGreenNew)
            
            Spacer()
                .frame(height: 12)
            
            TabView(selection: $currentPage) {
                ForEach(0..<examples.count, id: \.self) { index in
                    HStack(spacing: 0) {
                        AsyncImage(url: URL(string: examples[index].imageUrl)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 92)
                                .background(.blue)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 92)
                                .frame(height: 92)
                                .tint(Color.gentiGreenNew)
                        }
                        Text(examples[index].description)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(16)
                    }
                    .background(.gentiGrayNew)
                    .frame(maxWidth: .infinity)
                    .frame(height: 92)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                        
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 92)
            Spacer()
                .frame(height: 16)

            
            HStack(spacing: 12) {
                ForEach(0..<examples.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.gentiGreenNew : Color.white.opacity(0.3))
                        .frame(width: index == currentPage ? 8 : 6, height: index == currentPage ? 8 : 6)
                }
            }
            .padding(.top, 16)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            Color.geintiBackground
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            CustomTextField(viewModel: self.viewModel)
        }
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
}

#Preview {
    FirstGeneratorView(viewModel: FirstGeneratorViewModel(router: .init()))
}

struct CustomTextField: View {
    @State var message: String = ""
    var viewModel: FirstGeneratorViewModel
    
    init(viewModel: FirstGeneratorViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack(alignment: .bottom) {
            HStack(spacing: 8) {
                withAnimation(.easeInOut) {
                    TextField("", text: $message, axis: .vertical)
                        .pretendard(.body_14_medium)
                        .foregroundStyle(.white)
                        .placeholder(when: message.isEmpty) {
                            Text("만들고 싶은 사진을 설명해주세요.")
                                .pretendard(.body_14_medium)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .lineLimit(...4)
                }
            }
            .padding(.vertical, 8)
            .padding(.bottom, 3)
            .padding(.horizontal, 12)
            .background(.geintiBackground)
            
            // Send button
            if message != "" {
                Button {
                    self.viewModel.sendAction(.nextButton(self.message))
                } label: {
                    Image(.desActive)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                }
            } else {
                Button {
                } label: {
                    Image(.desNonActive)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                }
            }
        }
        .padding(.leading , 14)
        .padding(.trailing, 10)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity)
        .background(.geintiBackground)
        .cornerRadius(10, corners: .allCorners)
        .padding(16)
        .background(.gentiGrayNew)
        .cornerRadius(20, corners: .topLeft)
        .cornerRadius(20, corners: .topRight)
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
