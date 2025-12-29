//
//  View+Extensions.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


  import SwiftUI                                                                                                               
                                                                                                                               
  extension View {                                                                                                             
      func hideKeyboard() {                                                                                                    
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)           
      }                                                                                                                        
  }                                                                                                                            
   