//
//  PopupImagePickerView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Photos

import SwiftfulUI

enum ImagePickerType {
    case reference, faces
}

struct PopupImagePickerView: View {

    @ObservedObject var imagePickerModel: ImagePickerViewModel
    @EnvironmentObject var generatorViewModel: GeneratorViewModel
    @Environment(\.dismiss) private var dismiss
    let pickerType: ImagePickerType
    
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            VStack(spacing: 0) {
                headerView()
                    .padding([.horizontal, .top])
                    .padding(.bottom, 10)
                
                albumImageScrollView()
            } //:VSTACK
            
            selectButton()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            
        } //:ZSTACK
    }
}

private extension PopupImagePickerView {
    func albumImageScrollView() -> some View {
        ScrollViewWithOnScrollChanged {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 3)) {
                ForEach(imagePickerModel.fetchedImages) { imageAsset in
                    albumImage(from: imageAsset)
                        .aspectRatio(1, contentMode: .fit)
                        .readingFrame { frame in
                            guard imagePickerModel.cellHeight == 0 else { return }
                            imagePickerModel.cellHeight = frame.height
                        }
                }
            }

        } onScrollChanged: { origin in
            if imagePickerModel.scrollViewHeight > origin.y {
                self.imagePickerModel.getPhotosWithPagination()
            }
        }
        .padding(.horizontal, 10)
        .onReadSize({ size in
            self.imagePickerModel.scrollViewHeight = size.height
        })
    }
    
    func selectButton() -> some View {
        Button {
            // Action
            switch pickerType {
            case .faces:
                self.generatorViewModel.setFaceImageAsses(assets: imagePickerModel.selectedImages)
            case .reference:
                self.generatorViewModel.setReferenceImageAsset(asset: imagePickerModel.selectedImages[0])
            }
            
            dismiss()
        } label: {
            Text("\(imagePickerModel.selectedImageCount)/\(imagePickerModel.limit)추가하기")
                .pretendard(.headline4)
                .foregroundStyle(imagePickerModel.isReachLimit ? .white : .black)
                .padding(.horizontal, 50)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(imagePickerModel.isReachLimit ? .green1 : .gray5)
                )
                .padding(.bottom, 10)
                
        }
        .disabled(!imagePickerModel.isReachLimit)
    }
    
    func headerView() -> some View {
        HStack {
            Text("\(imagePickerModel.limit)장의 이미지를 선택해주세요")
                .pretendard(.headline4)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                // Action
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.black)
            }
        } //:HSTACK
    }
    
    func albumImage(from imageAsset: ImageAsset) -> some View {
            ZStack {
                PHAssetImageView(from: imageAsset.asset)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.1))
                    Circle()
                        .fill(.white.opacity(0.2))
                    Circle()
                        .stroke(.white, lineWidth: 1)
                    
                    if let index = imagePickerModel.selectedImages.firstIndex(where: { asset in
                        asset.id == imageAsset.id
                    }) {
                        Circle()
                            .fill(.gentiGreen)
                        Text("\(imagePickerModel.selectedImages[index].assetIndex + 1)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                    }
                    
                }
                .frame(width: 15, height: 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(4)
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    if let index = imagePickerModel.selectedImages.firstIndex(where: { asset in
                        return asset.id == imageAsset.id
                    }) {
                        imagePickerModel.selectedImages.remove(at: index)
                        imagePickerModel.selectedImages.enumerated().forEach { item in
                            imagePickerModel.selectedImages[item.offset].assetIndex = item.offset
                        }
                    } else {
                        guard !imagePickerModel.isReachLimit else { return }
                        var newAsset = imageAsset
                        newAsset.assetIndex = imagePickerModel.selectedImages.count
                        imagePickerModel.selectedImages.append(newAsset)
                    }
                }
            }
    }
}
