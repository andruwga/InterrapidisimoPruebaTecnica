//
//  Bundle+Extensions.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


  import Foundation                                                                                                            
                                                                                                                               
  extension Bundle {                                                                                                           
      var appVersion: String {                                                                                                 
          return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"                                           
      }                                                                                                                        
                                                                                                                               
      var buildNumber: String {                                                                                                
          return infoDictionary?["CFBundleVersion"] as? String ?? "1"                                                          
      }                                                                                                                        
  }   