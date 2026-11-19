//
//  FavoriteAPOD.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 18/11/26.
//

import SwiftData
import Foundation

@Model
final class FavoriteAPOD {
    
    var date: String //pode ser unica  visto que so há uma publicacao por data
    var title: String
    var hdurl: String?
    var credit: String?
    
    init(date: String, title: String, hdurl: String?, credit: String?) {
        self.date = date
        self.title = title
        self.hdurl = hdurl
        self.credit = credit
    }
    
}
