//
//  PopupImagePickerView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Photos

import SwiftfulUI

struct PopupImagePickerView: View {

    @State var viewModel: ImagePickerViewModel
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            VStack(spacing: 0) {
                headerView()
                albumImageScrollView()
            } //:VSTACK
            selectButton()
        } //:ZSTACK
        .onDisappear {
            viewModel.sendAction(.viewDidAppear)
        }
    }
    
    func albumImageScrollView() -> some View {
        ScrollViewWithOnScrollChanged {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 3), count: 3), spacing: 3) {
                ForEach(viewModel.state.fetchedImages) { imageAsset in
                    albumImage(from: imageAsset)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .readingFrame { frame in
                viewModel.sendAction(.readContentHight(frame.height))
            }

        } onScrollChanged: { origin in
            viewModel.sendAction(.scroll(origin.y))
        }
        .onReadSize { size in
            self.viewModel.scrollViewHeight = size.height
        }
    }
    func selectButton() -> some View {
        Capsule()
            .fill(viewModel.state.isReachLimit ? .green1 : .gray3)
            .frame(width: 216, height: 50)
            .overlay(alignment: .center) {
                Text("\(viewModel.state.selectedImages.count) / \(viewModel.limit) 장의 사진 추가하기")
                    .pretendard(.headline4)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 41)
            .asButton {
                viewModel.sendAction(.addImageButtonTap)
            }
            .disabled(!viewModel.state.isReachLimit)
    }
    
    func headerView() -> some View {
        HStack {
            Text("\(viewModel.limit)장의 이미지를 선택해주세요")
                .pretendard(.headline4)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "xmark")
                .font(.title2)
                .foregroundStyle(.black)
                .asButton {
                    viewModel.sendAction(.xmarkTap)
                }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 10)
    }
    
    func albumImage(from imageAsset: ImageAsset) -> some View {
            ZStack {
                PHAssetImageView(viewModel: PHAssetImageViewModel(phassetImageUseCase: PHAssetImageUseCaseImpl(service: PHAssetImageServiceImpl())), asset: imageAsset.asset)
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.1))
                    Circle()
                        .fill(.white.opacity(0.2))
                    Circle()
                        .stroke(.white, lineWidth: 1)
                    
                    if let index = viewModel.index(of: imageAsset) {
                        Circle()
                            .fill(.gentiGreen)
                        Text("\(viewModel.state.selectedImages[index].assetIndex + 1)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 15, height: 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(6)
                
                if viewModel.containsInSelectedImages(imageAsset) {
                    Rectangle()
                        .strokeBorder(.green1, style: .init(lineWidth: 2))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    viewModel.sendAction(.selectImage(imageAsset))
                }
            }
    }
}
