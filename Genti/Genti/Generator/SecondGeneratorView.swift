//
//  SecondGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct SecondGeneratorView: View {
    
    @State private var selectedAngle: PhotoAngle? = nil
    @State private var selectedFrame: PhotoFrame? = nil
    
    var angleAndFrameSelected: Bool {
        return selectedAngle != nil && selectedFrame != nil
    }
    
    var onXmarkPressed: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            VStack(spacing: 0) {
                navigationView()
                    .padding(.horizontal, 24)
                
                headerView()
                    .padding(.top, 10)
                
                
                VStack(spacing: 14) {
                    angleSelectView()
                    frameSelectView()
                } //:VSTACK
                .padding(.horizontal, 16)
                .padding(.top, 25)
                
                Spacer()
                
                nextButton()
                    .padding(.horizontal, 28)

                exampleImageView()
                    .padding(.top, 43)
            } //:VSTACK
        } //:ZSTACK
    }
    
    private func navigationView() -> some View {
        HStack {
            Image("Back_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 29, height: 29)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    print("백버튼이 눌림")
                }
            Spacer()
            Image("Xmark_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 29, height: 29)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    print("닫기버튼이 눌림")
                }
        } //:HSTACK
    }
    
    private func headerView() -> some View {
        VStack(alignment: .center, spacing: 13) {
            Image("Genti_LOGO")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 38)
            
            ProgressView(value: 2, total: 3)
                .frame(width: 83, height: 3)
                .background(.gray5)
                .tint(.gentiGreen)
        } //:VSTACK
    }
    
    private func angleSelectView() -> some View {
        VStack(spacing: 13) {
            Text("카메라 앵글을 골라주세요📷")
                .pretendard(.normal)
            
            VStack(spacing: 7) {

                HStack(spacing: 9) {
                    ForEach(PhotoAngle.selections, id: \.self) { angle in
                        Image(angle.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if selectedAngle == angle {
                                    Rectangle()
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.green1)
                                }

                            }
                            .onTapGesture {
                                selectedAngle = angle
                            }
                    }
                } //:HSTACK
                HStack(spacing: 4) {
                    Text("앵글은 자유롭게 맡길래요")
                        .pretendard(.description)
                        .foregroundStyle(selectedAngle == .free ? .green1 : .gray3)
                    Image(selectedAngle == .free ? PhotoAngle.freeSelectedImage : PhotoAngle.free.image)
                } //:HSTACK
                .background(.black.opacity(0.001))
                .onTapGesture {
                    selectedAngle = .free
                }
            } //:VSTACK
            
        } //:VSTACK
    }
    
    private func frameSelectView() -> some View {
        VStack(spacing: 13) {
            Text("프레임을 골라주세요")
                .pretendard(.normal)
            
            VStack(spacing: 7) {
                HStack(spacing: 9) {
                    ForEach(PhotoFrame.selections, id: \.self) { frame in
                        Image(frame.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if selectedFrame == frame {
                                    Rectangle()
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.green1)
                                }

                            }
                            .onTapGesture {
                                selectedFrame = frame
                            }
                    }
                } //:HSTACK
                HStack(spacing: 4) {
                    Text("프레임은 자유롭게 맡길래요")
                        .pretendard(.description)
                        .foregroundStyle(selectedFrame == .free ? .green1 : .gray3)
                    Image(selectedFrame == .free ? PhotoFrame.freeSelectedImage : PhotoAngle.free.image)
                } //:HSTACK
                .background(.black.opacity(0.001))
                .onTapGesture {
                    selectedFrame = .free
                }
            } //:VSTACK
            
        } //:VSTACK
    }
    
    private func nextButton() -> some View {
        Button {
            // Action
            print("angle = \(String(describing: selectedAngle))")
            print("frame = \(String(describing: selectedFrame))")
        } label: {
            Text("다음으로")
                .pretendard(.headline1)
                .foregroundStyle(angleAndFrameSelected ? .white : .black)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(angleAndFrameSelected ? .green1 : .gray5)
                .clipShape(.rect(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .disabled(!angleAndFrameSelected)
    }
    
    private func exampleImageView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("예시 사진을 참고해보세요")
                .pretendard(.description)
                .foregroundStyle(.black)
                .padding(.horizontal, 28)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(ExampleImage.mocks, id: \.id) { image in
                        Image(image.imageName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 150)

                    }
                } //:HSTACK
                .padding(.horizontal, 28)
            } //:SCROLL
            .scrollIndicators(.hidden)
        } //:VSTACK
    }
}

#Preview {
    SecondGeneratorView()
}
