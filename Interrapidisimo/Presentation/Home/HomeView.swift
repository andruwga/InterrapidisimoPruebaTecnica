//
//  HomeView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import SwiftUI

struct HomeView: View {
	@StateObject private var viewModel = HomeViewModel()
	@Binding var navigationPath: [AppRoute]

	var body: some View {
		ZStack {
			if viewModel.isLoading {
				LoadingView()
			} else if let error = viewModel.errorMessage {
				ErrorView(message: error) {
					viewModel.loadUser()
				}
			} else if let user = viewModel.user {
				ScrollView {
					VStack(spacing: 25) {
						VStack(spacing: 8) {
							Image(systemName: "person.circle.fill")
								.font(.system(size: 80))
								.foregroundColor(.blue)

							Text("Bienvenido")
								.font(.title2)
								.foregroundColor(.secondary)

							Text(user.nombre)
								.font(.title)
								.fontWeight(.bold)
						}
						.padding(.vertical, 20)

						VStack(alignment: .leading, spacing: 12) {
							InfoRow(label: "Usuario", value: user.usuario)
							Divider()
							InfoRow(label: "Identificación", value: user.identificacion)
						}
						.padding()
						.background(Color(.systemGray6))
						.cornerRadius(12)
						.padding(.horizontal)

						
						VStack(spacing: 15) {
							Button {
								navigationPath.append(.tables)
							} label: {
								MenuButton(
									title: "Tablas",
									icon: "list.bullet.rectangle",
									color: .blue
								)
							}
							.buttonStyle(PlainButtonStyle())

							Button {
								navigationPath.append(.localities)
							} label: {
								MenuButton(
									title: "Localidades",
									icon: "map",
									color: .green
								)
							}
							.buttonStyle(PlainButtonStyle())

							Button {
								navigationPath.append(.photos)
							} label: {
								MenuButton(
									title: "Fotos",
									icon: "camera.fill",
									color: .orange
								)
							}
							.buttonStyle(PlainButtonStyle())
						}
						.padding(.horizontal)
					}
					.padding(.vertical)
				}
			}
		}
		.navigationTitle("Inicio")
		.navigationBarTitleDisplayMode(.automatic)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					viewModel.logout()
					navigationPath.removeAll()
					navigationPath.append(.login)
				} label: {
					Label("Cerrar Sesión", systemImage: "rectangle.portrait.and.arrow.right")
						.foregroundColor(.red)
				}
				
			}
		}
		.onAppear {
			viewModel.loadUser()
		}
	}
}

struct InfoRow: View {
	let label: String
	let value: String

	var body: some View {
		HStack {
			Text(label)
				.fontWeight(.medium)
				.foregroundColor(.secondary)
			Spacer()
			Text(value)
				.fontWeight(.semibold)
		}
	}
}

struct MenuButton: View {
	let title: String
	let icon: String
	let color: Color

	var body: some View {
		HStack {
			Image(systemName: icon)
				.font(.title2)
				.foregroundColor(color)
				.frame(width: 50)

			Text(title)
				.font(.headline)
				.foregroundColor(.primary)

			Spacer()

			Image(systemName: "chevron.right")
				.foregroundColor(.secondary)
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(12)
	}
}
