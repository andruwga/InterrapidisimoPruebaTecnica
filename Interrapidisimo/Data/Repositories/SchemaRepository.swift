//
//  SchemaRepositoryProtocol.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

protocol SchemaRepositoryProtocol {
    func saveTables(_ tables: [SchemaTable]) throws
    func getTables() throws -> [SchemaTable]
    func clearTables() throws
}

final class SchemaRepository: SchemaRepositoryProtocol {
    private let database: SQLiteClient

    init(database: SQLiteClient = .shared) {
        self.database = database
    }

    func saveTables(_ tables: [SchemaTable]) throws {
        try clearTables()

        for table in tables {
            let query = """
            INSERT INTO schema_tables (table_name)
            VALUES ('\(table.tableName)');
            """
            try database.execute(query)
        }
    }

    func getTables() throws -> [SchemaTable] {
        let query = "SELECT * FROM schema_tables ORDER BY id;"
        let results = try database.query(query)

        return results.compactMap { row in
            guard let id = row["id"] as? Int,
                  let tableName = row["table_name"] as? String else {
                return nil
            }

            return SchemaTable(id: id, tableName: tableName)
        }
    }

    func clearTables() throws {
        let query = "DELETE FROM schema_tables;"
        try database.execute(query)
    }
}
