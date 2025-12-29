//
//  SyncSchemaUseCase.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation


struct SyncSchemaUseCase {
    private let schemaService: SchemaServiceProtocol
    private let schemaRepository: SchemaRepositoryProtocol

    init(
        schemaService: SchemaServiceProtocol? = nil,
        schemaRepository: SchemaRepositoryProtocol? = nil
    ) {
	
		if Configuration.Flags.useMockSchema {
			self.schemaService = schemaService ?? MockSchemaService()
		} else {
			self.schemaService = schemaService ?? InterrapidisimoAPI.SchemaService()
		}

		self.schemaRepository = schemaRepository ?? SchemaRepository()
    }


    func execute() async throws -> [SchemaTable] {
        let response = try await schemaService.getSchema()

        let tables = response.toSchemaTables()

        try schemaRepository.saveTables(tables)

        return tables
    }


    func getStoredTables() throws -> [SchemaTable] {
        return try schemaRepository.getTables()
    }
}
