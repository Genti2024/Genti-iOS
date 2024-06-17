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

    @State var imagePickerModel: ImagePickerViewModel
    @State var generatorViewModel: GetImageFromAlbum
    @Environment(\.dismiss) private var dismiss
    
    init(limitCount: Int, viewModel: GetImageFromAlbum) {
        self.imagePickerModel = ImagePickerViewModel(limitCount: limitCount)
        self.generatorViewModel = viewModel
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
            imagePickerModel.removeAll()
        }
    }
    
    func albumImageScrollView() -> some View {
        ScrollViewWithOnScrollChanged {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 3), count: 3), spacing: 3) {
                ForEach(imagePickerModel.fetchedImages) { imageAsset in
                    albumImage(from: imageAsset)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .readingFrame { frame in
                if imagePickerModel.contentSize != frame.height {
                    imagePickerModel.contentSize = frame.height
                }
            }

        } onScrollChanged: { origin in
            let height = imagePickerModel.scrollViewHeight
            if height > imagePickerModel.contentSize + origin.y {
                self.imagePickerModel.getPhotos()
            }
        }
        .onReadSize({ size in
            self.imagePickerModel.scrollViewHeight = size.height
        })
    }
    func selectButton() -> some View {
        Button {
            // Action
            self.generatorViewModel.setReferenceImageAssets(assets: imagePickerModel.selectedImages)
            dismiss()
        } label: {
            Text("\(imagePickerModel.selectedImageCount) / \(imagePickerModel.limit) 장의 사진 추가하기")
                .pretendard(.headline4)
                .foregroundStyle(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(imagePickerModel.isReachLimit ? .green1 : .gray3)
                )
        }
        .disabled(!imagePickerModel.isReachLimit)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, .height(ratio: 0.03))
    }
    func headerView() -> some View {
        HStack {
            Text("\(imagePickerModel.limit)장의 이미지를 선택해주세요")
                .pretendard(.headline4)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                dismiss()
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
                
                PHAssetImageView(asset: imageAsset.asset)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.1))
                    Circle()
                        .fill(.white.opacity(0.2))
                    Circle()
                        .stroke(.white, lineWidth: 1)
                    
                    if let index = imagePickerModel.isSelected(from: imageAsset) {
                        Circle()
                            .fill(.gentiGreen)
                        Text("\(imagePickerModel.selectedImages[index].assetIndex + 1)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 15, height: 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(6)
                
                if let _ = imagePickerModel.isSelected(from: imageAsset) {
                    Rectangle()
                        .strokeBorder(.green1, style: .init(lineWidth: 2))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    updateImageSelection(for: imageAsset)
                }
            }
    }

}

private extension PopupImagePickerView {

    func updateImageSelection(for imageAsset: ImageAsset) {
        if let index = imagePickerModel.isSelected(from: imageAsset) {
            removeImage(at: index)
        } else {
            addImage(imageAsset)
        }
    }

    func removeImage(at index: Int) {
        imagePickerModel.selectedImages.remove(at: index)
        updateAssetIndices()
    }

    func addImage(_ imageAsset: ImageAsset) {
        guard !imagePickerModel.isReachLimit else { return }
        var newAsset = imageAsset
        newAsset.assetIndex = imagePickerModel.selectedImages.count
        imagePickerModel.selectedImages.append(newAsset)
    }

    func updateAssetIndices() {
        for index in imagePickerModel.selectedImages.indices {
            imagePickerModel.selectedImages[index].assetIndex = index
        }
    }
}
