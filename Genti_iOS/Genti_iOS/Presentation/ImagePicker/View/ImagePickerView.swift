//
//  ImagePickerView.swift
//  Genti_iOS
//
//  Created by uiskim on 9/2/24.
//

import SwiftUI
import Photos

import SwiftfulUI

struct ImagePickerView: View {

    @State var viewModel: ImagePickerViewModel
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            VStack(spacing: 0) {
                headerView()
                if viewModel.state.showAlbumList {
                    albumListView()
                } else {
                    albumImageScrollView()
                }
            } //:VSTACK
        } //:ZSTACK
        .onAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
    }
    
    func albumListView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.state.albums, id: \.name) { album in
                    VStack {
                        Text("\(album.name)")
                            .pretendard(.headline2)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(album.count)")
                            .pretendard(.small)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .fill(.gray3)
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 16)
                    .background(.black.opacity(0.01))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            self.viewModel.sendAction(.selectAlbum(album))
                        }
                    }
                }
            }
        }
        .background(.backgroundWhite)
    }
    
    func albumImageScrollView() -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 3), count: 3), spacing: 3) {
                ForEach(viewModel.state.fetchedImages, id: \.self) { imageAsset in
                    albumImage(from: imageAsset)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            selectButton()
        }
    }
    
    func headerView() -> some View {
        HStack {
            HStack {
                Text("\(self.viewModel.state.selectedAlbum?.name ?? "Recents")")
                    .pretendard(.headline2)
                    .foregroundStyle(.black)
                if self.viewModel.state.showAlbumList {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundStyle(.black)
                } else {
                    Image(systemName: "arrowtriangle.down.fill")
                        .foregroundStyle(.black)
                }

            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    self.viewModel.state.showAlbumList.toggle()
                }
                
            }
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
    
    func albumImage(from imageAsset: PHAsset) -> some View {
        PHAssetImageView(viewModel: PHAssetImageViewModel(phassetImageRepository: PHAssetImageRepositoryImpl(service: PHAssetImageServiceImpl())), asset: imageAsset)
            .overlay {
                if viewModel.state.selectedImages.contains(imageAsset) {
                    Rectangle()
                        .strokeBorder(.gentiGreen, style: .init(lineWidth: 2))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(alignment: .topTrailing) {
                            Circle()
                                .fill(.gentiGreen)
                                .frame(width: 15, height: 15)
                                .padding(6)
                        }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.black.opacity(0.1))
                        Circle()
                            .fill(.white.opacity(0.2))
                        Circle()
                            .stroke(.white, lineWidth: 1)
                    }
                    .frame(width: 15, height: 15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(6)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    viewModel.sendAction(.selectImage(imageAsset))
                }
            }
    }
    
    func selectButton() -> some View {
        Capsule()
            .fill(viewModel.reachImageLimit ? .green1 : .gray3)
            .frame(width: 216, height: 50)
            .overlay(alignment: .center) {
                Text("\(viewModel.state.selectedImages.count) / \(viewModel.limit) 장의 사진 추가하기")
                    .pretendard(.headline4)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 41)
            .asButton {
                print(#fileID, #function, #line, "- 사진선택완료")
                viewModel.sendAction(.addImageButtonTap)
            }
            .disabled(!viewModel.reachImageLimit)
    }
}
