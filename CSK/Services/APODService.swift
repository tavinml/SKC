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
    
    return try JSONDecoder().decode([APOD].self,
                                    from: data)
}

func fetchAPOD(for date: Date) async throws -> APOD {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    let dateCode = formatter.string(from: date)
    
    guard let url = URL(string: "https://science.nasa.gov/wp-json/wp/v2/apod-basic/\(dateCode)") else {
        throw URLError(.badURL)
    }
    
    let (data,response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode(APOD.self,
                                    from: data)

}
