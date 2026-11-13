//
//  StackComponent.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 13/11/26.
//

import UIKit

class StackComponent: UIStackView {
    init(
        axis: NSLayoutConstraint.Axis,
        arrangedSubViews: [UIView],
        spacing: CGFloat = 16,
        alignment: UIStackView.Alignment = .fill
    ) {
        super.init(frame: .zero)
        
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = .fill
        self.translatesAutoresizingMaskIntoConstraints = false
        //padrão da UIStackView, são as subviews dela
        arrangedSubViews.forEach { addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("A classe Stack precisa ser inicializada")
    }
}
