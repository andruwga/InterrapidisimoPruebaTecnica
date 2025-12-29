//
//  PhotosView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import SwiftUI

struct PhotosView: View {
    @StateObject private var viewModel = PhotosViewModel()
    @Binding var navigationPath: [AppRoute]
    @State private var capturedImage: UIImage?
    @State private var showPhotoSelector = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        viewModel.loadPhotos()
                    }
                } else if viewModel.photos.isEmpty {
                    EmptyStateView(
                        message: "No hay fotos guardadas\nToca el botón de cámara para comenzar",
                        icon: "camera"
                    )
                } else {
                    List(viewModel.photos) { photo in
                        Button {
                            if let index = viewModel.photos.firstIndex(where: { $0.id == photo.id }) {
                                navigationPath.append(.photoDetail(photos: viewModel.photos, index: index))
                            }
                        } label: {
                            HStack(spacing: 15) {
                                Image(uiImage: photo.thumbnail)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                Text(photo.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                HStack(spacing: 20) {
                    Button {
                        Task {
                            await viewModel.openCamera()
                        }
                    } label: {
                        Label("Tomar Foto", systemImage: "camera.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    Button {
                        showPhotoSelector = true
                    } label: {
                        Label("Ver Foto", systemImage: "photo.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.photos.isEmpty)
                    .opacity(viewModel.photos.isEmpty ? 0.6 : 1.0)
                }
                .padding()
                .background(Color(.systemGray6))
            }
        }
        .navigationTitle("Fotos")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadPhotos()
        }
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            ImagePicker(image: $capturedImage, sourceType: .camera)
                .ignoresSafeArea()
        }

        .onChange(of: capturedImage) { _, newImage in
            if let image = newImage {
                viewModel.savePhoto(image)
                capturedImage = nil
            }
        }

        .alert("Permiso de Cámara Requerido", isPresented: $viewModel.cameraPermissionDenied) {
            Button("Cancelar", role: .cancel) { }
            Button("Configuración") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        } message: {
            Text("Por favor habilita el acceso a la cámara en Configuración para tomar fotos.")
        }

        .confirmationDialog("Seleccionar Foto", isPresented: $showPhotoSelector, titleVisibility: .visible) {
            ForEach(Array(viewModel.photos.enumerated()), id: \.element.id) { index, photo in
                Button(photo.name) {
                    navigationPath.append(.photoDetail(photos: viewModel.photos, index: index))
                }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Selecciona una foto para ver en pantalla completa")
        }
    }
}
