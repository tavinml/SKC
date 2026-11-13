//
//  APODService.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 12/11/26.
//

import Foundation

func fetchAPOD(from url: URL) async throws -> [APOD] {
    let (data, response) = try await URLSession.shared.data(from: url)
    guard ( response as? HTTPURLResponse)?.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode([APOD].self, from: data)
}
