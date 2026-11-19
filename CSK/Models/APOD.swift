//
//  APOD.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 12/11/26.
//

import Foundation
//codable faz com que seja possivel criar um apod a partir de um json
struct APOD: Codable {
    let title: String
    let date: String
    let hdurl: String?
    let credit: String?
}
