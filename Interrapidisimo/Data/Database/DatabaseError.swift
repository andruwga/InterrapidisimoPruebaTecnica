//
//  DatabaseError.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


  import Foundation                                                                                                            
                                                                                                                               
  enum DatabaseError: LocalizedError {                                                                                         
      case failedToOpen(String)                                                                                                
      case failedToCreate                                                                                                      
      case failedToExecute(String)                                                                                             
      case noData                                                                                                              
      case invalidData                                                                                                         
                                                                                                                               
      var errorDescription: String? {                                                                                          
          switch self {                                                                                                        
          case .failedToOpen(let path):                                                                                        
              return "No se pudo abrir la base de datos en: \(path)"                                                           
          case .failedToCreate:                                                                                                
              return "No se pudo crear la base de datos"                                                                       
          case .failedToExecute(let query):                                                                                    
              return "Error al ejecutar: \(query)"                                                                             
          case .noData:                                                                                                        
              return "No se encontraron datos"                                                                                 
          case .invalidData:                                                                                                   
              return "Datos inválidos en la base de datos"                                                                     
          }                                                                                                                    
      }                                                                                                                        
  }                                                                                                                            
     