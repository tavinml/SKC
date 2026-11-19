//
//  StringHTML.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 16/11/26.
//

import Foundation
import UIKit

extension String {

    var htmlToPlainText: String {
        guard let data = data(using: .utf8),
              let attributedText = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
              ) else {
            return self
        }

        return attributedText.string
    }
}
