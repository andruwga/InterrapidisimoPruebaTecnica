//
//  SchemaServiceProtocol.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

protocol SchemaServiceProtocol {
	func getSchema() async throws -> SchemaResponse
}
