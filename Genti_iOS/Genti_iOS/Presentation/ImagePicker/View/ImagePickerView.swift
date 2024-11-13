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
            Color.geintiBackground
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
                            .pretendard(.tempHeadline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                        
                        Text("\(album.count)")
                            .pretendard(.small)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .fill(.gray5)
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 5)
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
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(LinearGradient(colors: [Color.geintiBackground.opacity(0), Color.geintiBackground], startPoint: .top, endPoint: .center))
                .frame(height: 120)
        })
        .ignoresSafeArea()
        .overlay(alignment: .bottom, content: {
            selectButton()
        })

    }
    
    func headerView() -> some View {
        HStack {
            HStack {
                Text("\(self.viewModel.state.selectedAlbum?.name ?? "Recents")")
                    .pretendard(.subtitle1_18_bold)
                    .foregroundStyle(.white)
                Image(self.viewModel.state.showAlbumList ? .arrowDropUpNew : .arrowDropDownNew)
                    .foregroundStyle(.white)
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    self.viewModel.state.showAlbumList.toggle()
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "xmark")
                .font(.title3)
                .foregroundStyle(.gray)
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
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    viewModel.sendAction(.selectImage(imageAsset))
                }
            }
    }
    
    func selectButton() -> some View {
        Text("\(viewModel.state.selectedImages.count) / \(viewModel.limit) 장의 사진 추가하기")
            .pretendard(.headline4)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(viewModel.reachImageLimit ? .gentiGreenNew : .gentiDisabled)
            .cornerRadius(10, corners: .allCorners)
            .padding(.horizontal, 16)
            .asButton {
                print(#fileID, #function, #line, "- 사진선택완료")
                viewModel.sendAction(.addImageButtonTap)
            }
            .disabled(!viewModel.reachImageLimit)
    }
}
