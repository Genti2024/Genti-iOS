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
    
    init(viewModel: ImagePickerViewModel) {
        self.viewModel = viewModel
    }
    
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
                // MARK: - frame 길이 갱신
                viewModel.sendAction(.readContentHight(frame.height))
            }

        } onScrollChanged: { origin in
            viewModel.sendAction(.scroll(origin.y))
        }
        .onReadSize({ size in
            // MARK: - scrollview자체의 높이(contentsize아님)설정
            self.viewModel.scrollViewHeight = size.height
        })
    }
    func selectButton() -> some View {
        Button {
            // Action
            // MARK: - 추가하기 버튼 눌렀을때
            viewModel.sendAction(.addImageButtonTap)
        } label: {
            Text("\(viewModel.state.selectedImages.count) / \(viewModel.limit) 장의 사진 추가하기")
                .pretendard(.headline4)
                .foregroundStyle(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(viewModel.state.isReachLimit ? .green1 : .gray3)
                )
        }
        .disabled(!viewModel.state.isReachLimit)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, .height(ratio: 0.03))
    }
    func headerView() -> some View {
        HStack {
            Text("\(viewModel.limit)장의 이미지를 선택해주세요")
                .pretendard(.headline4)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                viewModel.sendAction(.xmarkTap)
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.black)
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 10)
    }
    func albumImage(from imageAsset: ImageAsset) -> some View {
            ZStack {
                
                PHAssetImageView(viewModel: PHAssetImageViewModel(), asset: imageAsset.asset)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.1))
                    Circle()
                        .fill(.white.opacity(0.2))
                    Circle()
                        .stroke(.white, lineWidth: 1)
                    
                    if let index = viewModel.isSelected(from: imageAsset) {
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
                
                if let _ = viewModel.isSelected(from: imageAsset) {
                    Rectangle()
                        .strokeBorder(.green1, style: .init(lineWidth: 2))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    // MARK: - image선택했을때
                    viewModel.sendAction(.selectImage(imageAsset))
                }
            }
    }

}
