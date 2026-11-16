//
//  ImageService.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 13/11/26.
//

import UIKit

func fetchImage(from url: URL ) async throws -> UIImage {
    let (data, response) = try await URLSession.shared.data(from: url) //baixa os dados recebidos
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { //verifica se a resposta http foi sucesso
        throw URLError(.badServerResponse)
    }
    
    guard let image = UIImage(data: data) else { //tenta transformar os dados em uma imagem
        throw URLError(.cannotDecodeContentData)
    }
    
    return image
}
