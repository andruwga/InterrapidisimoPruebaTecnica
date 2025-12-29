//
//  TablesViewModel.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Combine
import Foundation

@MainActor
final class TablesViewModel: ObservableObject {
    @Published var tables: [SchemaTable] = []
    @Published var isLoading = true
    @Published var errorMessage: String?

    private let syncSchemaUseCase: SyncSchemaUseCase

    init(syncSchemaUseCase: SyncSchemaUseCase? = nil) {
		self.syncSchemaUseCase = syncSchemaUseCase ?? .init()
    }

    func loadTables() {
        isLoading = true
        errorMessage = nil

        do {
            tables = try syncSchemaUseCase.getStoredTables()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
