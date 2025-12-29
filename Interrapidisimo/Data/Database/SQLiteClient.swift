//
//  SQLiteClient.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation
import SQLite3

final class SQLiteClient {
    static let shared = SQLiteClient()

    private var db: OpaquePointer?
    private let dbPath: String

    private init() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else {
            fatalError("No se pudo acceder al directorio de documentos")
        }

        dbPath = documentsURL.appendingPathComponent("interrapidisimo.db").path

        #if DEBUG
            print("📂 Database path: \(dbPath)")
        #endif
    }

    func openDatabase() throws {
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            throw DatabaseError.failedToOpen(dbPath)
        }

        try createTables()
    }

    func closeDatabase() {
        sqlite3_close(db)
    }

    private func createTables() throws {
        let createUserTable = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario TEXT NOT NULL,
            identificacion TEXT NOT NULL,
            nombre TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """

        let createSchemaTable = """
        CREATE TABLE IF NOT EXISTS schema_tables (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            table_name TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """

        let createPhotoTable = """
        CREATE TABLE IF NOT EXISTS photos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            image_data BLOB NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """

        try execute(createUserTable)
        try execute(createSchemaTable)
        try execute(createPhotoTable)
    }

    func execute(_ query: String) throws {
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            throw DatabaseError.failedToExecute(errorMessage)
        }

        defer {
            sqlite3_finalize(statement)
        }

        guard sqlite3_step(statement) == SQLITE_DONE else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            throw DatabaseError.failedToExecute(errorMessage)
        }
    }

    func query(_ query: String) throws -> [[String: Any]] {
        var statement: OpaquePointer?
        var results: [[String: Any]] = []

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            throw DatabaseError.failedToExecute(errorMessage)
        }

        defer {
            sqlite3_finalize(statement)
        }

        let columnCount = sqlite3_column_count(statement)

        while sqlite3_step(statement) == SQLITE_ROW {
            var row: [String: Any] = [:]

            for i in 0 ..< columnCount {
                let columnName = String(cString: sqlite3_column_name(statement, i))
                let columnType = sqlite3_column_type(statement, i)

                switch columnType {
                case SQLITE_INTEGER:
                    row[columnName] = Int(sqlite3_column_int64(statement, i))
                case SQLITE_FLOAT:
                    row[columnName] = sqlite3_column_double(statement, i)
                case SQLITE_TEXT:
                    row[columnName] = String(cString: sqlite3_column_text(statement, i))
                case SQLITE_BLOB:
                    let blobPointer = sqlite3_column_blob(statement, i)
                    let blobSize = sqlite3_column_bytes(statement, i)
                    if let blobPointer {
                        row[columnName] = Data(bytes: blobPointer, count: Int(blobSize))
                    } else {
                        row[columnName] = Data()
                    }
                case SQLITE_NULL:
                    row[columnName] = NSNull()
                default:
                    break
                }
            }

            results.append(row)
        }

        return results
    }
}
