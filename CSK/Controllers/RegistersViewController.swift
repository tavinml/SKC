//
//  RegistersViewController.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 18/11/26.
//

import SwiftUI
import UIKit
import SwiftData

final class RegistersViewController: UIViewController {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) nao foi implementado")
    }
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Nenhum registro criado"
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(emptyStateLabel)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
}

//private struct RegistersViewControllerPreview: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> RegistersViewController {
//        RegistersViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: RegistersViewController, context: Context) {}
//}
//
//#Preview {
//    RegistersViewControllerPreview()
//}
