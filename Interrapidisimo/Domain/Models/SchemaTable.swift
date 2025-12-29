//
//  SchemaTable.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


 import Foundation                                                                                                            
                                                                                                                               
  struct SchemaTable: Codable, Identifiable {                                                                                  
      let id: Int                                                                                                              
      let tableName: String                                                                                                    
                                                                                                                               
      init(id: Int, tableName: String) {                                                                                       
          self.id = id                                                                                                         
          self.tableName = tableName                                                                                           
      }                                                                                                                        
  }                                                                                                                            
                                                                                                                               
																								
  struct SchemaResponse: Codable {                                                                                             
      let tables: [String]                                                                                                     
                                                                                                                               
      enum CodingKeys: String, CodingKey {                                                                                     
          case tables = "Tables"                                                                                               
      }                                                                                                                        
                                                                                                                               
      func toSchemaTables() -> [SchemaTable] {                                                                                 
          return tables.enumerated().map { index, name in                                                                      
              SchemaTable(id: index + 1, tableName: name)                                                                      
          }                                                                                                                    
      }                                                                                                                        
  } 
