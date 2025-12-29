//
//  Photo.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


  import Foundation                                                                                                            
  import UIKit                                                                                                                 
                                                                                                                               
  struct Photo: Identifiable {                                                                                                 
      let id: Int                                                                                                              
      let name: String                                                                                                         
      let image: UIImage                                                                                                       
                                                                                                                               
      var thumbnail: UIImage {                                                                                                 
          return image.preparingThumbnail(of: CGSize(width: 100, height: 100)) ?? image                                        
      }                                                                                                                        
  } 