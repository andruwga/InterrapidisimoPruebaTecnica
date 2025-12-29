//
//  Endpoint.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


 import Foundation                                                                                                            
                                                                                                                               
  struct Endpoint {                                                                                                            
      let path: String                                                                                                         
      let method: HTTPMethod                                                                                                   
      let headers: [String: String]?                                                                                           
      let body: Data?                                                                                                          
      let timeout: TimeInterval                                                                                                
                                                                                                                               
      enum HTTPMethod: String {                                                                                                
          case get = "GET"                                                                                                     
          case post = "POST"                                                                                                   
          case put = "PUT"                                                                                                     
          case delete = "DELETE"                                                                                               
      }                                                                                                                        
                                                                                                                               
      init(                                                                                                                    
          path: String,                                                                                                        
          method: HTTPMethod = .get,                                                                                           
          headers: [String: String]? = nil,                                                                                    
          body: Data? = nil,                                                                                                   
          timeout: TimeInterval = 30                                                                                           
      ) {                                                                                                                      
          self.path = path                                                                                                     
          self.method = method                                                                                                 
          self.headers = headers                                                                                               
          self.body = body                                                                                                     
          self.timeout = timeout                                                                                               
      }                                                                                                                        
  }      