//
//  SecondGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct SecondGeneratorView: View {
    
    @EnvironmentObject var viewModel: GeneratorViewModel

    var onXmarkPressed: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            VStack(spacing: 0) {
                GeneratorNavigationView()
                    .padding(.horizontal, 24)
                
                GeneratorHeaderView(step: 2)
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

                GeneratorExampleView()
                    .padding(.top, 43)
            } //:VSTACK
        } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func angleSelectView() -> some View {
        VStack(spacing: 13) {
            Text("카메라 앵글을 골라주세요📷")
                .foregroundStyle(.black)
                .pretendard(.normal)
            
            VStack(spacing: 7) {
                HStack(spacing: 9) {
                    ForEach(PhotoAngle.selections, id: \.self) { angle in
                        Image(angle.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if viewModel.selectedAngle == angle {
                                    Rectangle()
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.green1)
                                }

                            }
                            .onTapGesture {
                                viewModel.selectedAngle = angle
                            }
                    }
                } //:HSTACK
                HStack(spacing: 4) {
                    Text("앵글은 자유롭게 맡길래요")
                        .pretendard(.description)
                        .foregroundStyle(viewModel.selectedAngle == .free ? .green1 : .gray3)
                    Image(viewModel.selectedAngle == .free ? PhotoAngle.freeSelectedImage : PhotoAngle.free.image)
                } //:HSTACK
                .background(.black.opacity(0.001))
                .onTapGesture {
                    viewModel.selectedAngle = .free
                }
            } //:VSTACK
            
        } //:VSTACK
    }
    
    private func frameSelectView() -> some View {
        VStack(spacing: 13) {
            Text("프레임을 골라주세요")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            VStack(spacing: 7) {
                HStack(spacing: 9) {
                    ForEach(PhotoFrame.selections, id: \.self) { frame in
                        Image(frame.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if viewModel.selectedFrame == frame {
                                    Rectangle()
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.green1)
                                }

                            }
                            .onTapGesture {
                                viewModel.selectedFrame = frame
                            }
                    }
                } //:HSTACK
                HStack(spacing: 4) {
                    Text("프레임은 자유롭게 맡길래요")
                        .pretendard(.description)
                        .foregroundStyle(viewModel.selectedFrame == .free ? .green1 : .gray3)
                    Image(viewModel.selectedFrame == .free ? PhotoFrame.freeSelectedImage : PhotoAngle.free.image)
                } //:HSTACK
                .background(.black.opacity(0.001))
                .onTapGesture {
                    viewModel.selectedFrame = .free
                }
            } //:VSTACK
            
        } //:VSTACK
    }
    
    private func nextButton() -> some View {
        Button {
            // Action
            print("angle = \(String(describing: viewModel.selectedAngle))")
            print("frame = \(String(describing: viewModel.selectedFrame))")
        } label: {
            Text("다음으로")
                .pretendard(.headline1)
                .foregroundStyle(viewModel.angleAndFrameSelected ? .white : .black)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(viewModel.angleAndFrameSelected ? .green1 : .gray5)
                .clipShape(.rect(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.angleAndFrameSelected)
    }
}

#Preview {
    SecondGeneratorView()
}
