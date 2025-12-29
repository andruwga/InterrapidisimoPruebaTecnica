//
//  User.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


  import Foundation                                                                                                            
                                                                                                                               
  struct User: Codable, Identifiable {                                                                                         
      let id: UUID                                                                                                             
      let usuario: String                                                                                                      
      let identificacion: String                                                                                               
      let nombre: String                                                                                                       
                                                                                                                               
      init(usuario: String, identificacion: String, nombre: String) {                                                          
          self.id = UUID()                                                                                                     
          self.usuario = usuario                                                                                               
          self.identificacion = identificacion                                                                                 
          self.nombre = nombre                                                                                                 
      }                                                                                                                        
  } 