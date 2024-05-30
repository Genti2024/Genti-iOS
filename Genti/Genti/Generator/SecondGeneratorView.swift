//
//  SecondGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct SecondGeneratorView: View {
    @EnvironmentObject var viewModel: GeneratorViewModel
    @Binding var generateFlow: [GeneratorFlow]
    
    var body: some View {
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                VStack(spacing: 0) {
                    GeneratorHeaderView(step: 2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .overlay(alignment: .leading) {
                            Image("Back_fill")
                                .resizable()
                                .frame(width: 29, height: 29)
                                .padding(11)
                                .background(.black.opacity(0.001))
                                .onTapGesture {
                                    self.viewModel.resetSecond()
                                    self.generateFlow.removeLast()
                                }
                                .padding(.leading, 17)
                        }
                        .padding(.top, 40)
                    
                    VStack(spacing: 12) {
                        ratioSelectView()
                        angleSelectView()
                        frameSelectView()
                    } //:VSTACK
                    .padding(.horizontal, 16)
                    .padding(.top, 19)
                    
                    Spacer()
                    
                    GeneratorNavigationButton(isActive: viewModel.angleOrFrameOrRatioIsEmpty) {
                        self.generateFlow.append(.thrid)
                    }
                    .padding(.bottom, 32)

                } //:VSTACK
            } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func ratioSelectView() -> some View {
        VStack(spacing: 0) {
            Text("사진의 비율을을 선택해주세요📷")
                .pretendard(.normal)
                .foregroundStyle(.black)
                .frame(height: 22)
            
            VStack(spacing: 5) {
                HStack(spacing: 4) {
                    Text("비율은 자유롭게 맡길래요")
                        .pretendard(.description)
                        .foregroundStyle(viewModel.selectedRatio == .free ? .green1 : .gray3)
                    Image(viewModel.selectedRatio == .free ? PhotoFrame.freeSelectedImage : PhotoAngle.free.image)
                } //:HSTACK
                .frame(height: 19)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    viewModel.selectedRatio = .free
                }
                
                HStack(spacing: 9) {
                    ForEach(PhotoRatio.selections, id: \.self) { frame in
                        Image(frame.image)
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width-32-8)/3)
                            .frame(height: (UIScreen.main.bounds.width-32-8)/3)
                            .overlay {
                                if viewModel.selectedRatio == frame {
                                    Rectangle()
                                        .strokeBorder(.green1, style: .init(lineWidth:2))
                                }

                            }
                            .onTapGesture {
                                viewModel.selectedRatio = frame
                            }
                    }
                } //:HSTACK
            } //:VSTACK

        } //:VSTACK
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func angleSelectView() -> some View {
        VStack(spacing: 0) {
            Text("카메라 앵글을 선택해주세요📷")
                .foregroundStyle(.black)
                .pretendard(.normal)
            
            VStack(spacing: 5) {
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
                
                HStack(spacing: 9) {
                    ForEach(PhotoAngle.selections, id: \.self) { angle in
                        Image(angle.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if viewModel.selectedAngle == angle {
                                    Rectangle()
                                        .strokeBorder(.green1, style: .init(lineWidth:2))
                                }

                            }
                            .onTapGesture {
                                viewModel.selectedAngle = angle
                            }
                    }
                } //:HSTACK
            } //:VSTACK
            
        } //:VSTACK
    }
    
    private func frameSelectView() -> some View {
        VStack(spacing: 0) {
            Text("원하는 프레임을 선택해주세요📷")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            VStack(spacing: 5) {
                
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
                
                HStack(spacing: 9) {
                    ForEach(PhotoFrame.selections, id: \.self) { frame in
                        Image(frame.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if viewModel.selectedFrame == frame {
                                    Rectangle()
                                        .strokeBorder(.green1, style: .init(lineWidth:2))
                                }

                            }
                            .onTapGesture {
                                viewModel.selectedFrame = frame
                            }
                    }
                } //:HSTACK

            } //:VSTACK
        } //:VSTACK
    }
}

#Preview {
    SecondGeneratorView(generateFlow: .constant([]))
        .environmentObject(GeneratorViewModel())
}
