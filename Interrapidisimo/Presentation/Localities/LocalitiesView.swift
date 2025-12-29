//
//  LocalitiesView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import SwiftUI

struct LocalitiesView: View {
	@StateObject private var viewModel = LocalitiesViewModel()

	var body: some View {
		ZStack {
			if viewModel.isLoading {
				LoadingView()
			} else if let error = viewModel.errorMessage {
				ErrorView(message: error) {
					viewModel.retry()
				}
			} else if viewModel.localities.isEmpty {
				EmptyStateView(
					message: "No hay localidades disponibles",
					icon: "map"
				)
			} else {
				List(viewModel.localities) { locality in
					VStack(alignment: .leading, spacing: 6) {
						Text(locality.abreviacionCiudad)
							.font(.headline)
							.foregroundColor(.blue)

						Text(locality.nombreCompleto)
							.font(.subheadline)
							.foregroundColor(.secondary)
					}
					.padding(.vertical, 4)
				}
			}
		}
		.navigationTitle("Localidades")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: {
					Task {
						await viewModel.loadLocalities()
					}
				}) {
					Image(systemName: "arrow.clockwise")
				}
			}
		}
		.task {
			await viewModel.loadLocalities()
		}
	}
}
