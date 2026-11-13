//
//  ViewController.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 09/11/26.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CSK: abriu o ViewController")
        setupView()
        setupConstraint()
        
        let endpoint  = "https://science.nasa.gov/wp-json/wp/v2/apod-basic/?api_key=DEMO_KEY"
        guard let url = URL(string: endpoint) else {
            return
        }
        
        Task {
            do {
                print("CSK: iniciando consulta ao APOD")
                let posts = try await fetchAPOD(from: url)
                print("APOD:", posts.first?.title ?? "Nenhuma opcao encontrada")
                print("APOD:", posts.first?.date ?? " Sem publicacao")
                titleLabel.text = posts.first?.title ?? "Nenhuma opção encontrada"
                dateLabel.text = posts.first?.date ?? "Nenhuma opção encontrada"
            } catch {
                print("Falha ao consultar o APOD:", error)
                titleLabel.text = "Não foi possivel carregar a publicacao"
            }
        }
    }

    //executado toda vez que minha view aparece na tela
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "carregando publicacao"
        label.textColor = .black
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "carregando data..."
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let apodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .secondaryLabel
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let button: UIButton = {
        
        let button = UIButton(type: .custom)
        button.setTitle("botao", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.green.cgColor
        button.tintColor = .systemCyan
        button.configuration = .glass()
        
        return button
    }()
    
    private lazy var headerStackView = StackComponent(axis: .vertical,
                                                      arrangedSubViews:[titleLabel, dateLabel],
                                                      spacing: 4
    )
    
    private func setupView() {
        view.backgroundColor = .white
//        view.addSubview(customView)
//        view.addSubview(button)
        view.addSubview(headerStackView)
        
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }
    
}

#Preview {
    let controller = ViewController()
    controller.title = "Explorar"
    return UINavigationController(rootViewController: controller)
}


