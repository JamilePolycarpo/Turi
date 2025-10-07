//
//  ViagemModel.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 05/10/25.
//

import Foundation


struct Trip: Identifiable{
    let id = UUID()
    let nome: String
    let data: Date
    let notas: String?
 
}

