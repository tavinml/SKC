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
        setupActions()
        
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
                print("APOD:", posts.first?.hdurl ?? "Publicação sem imagem")
                titleLabel.text = posts.first?.title ?? "Nenhuma opção encontrada"
                dateLabel.text = posts.first?.date ?? "Nenhuma opção encontrada"
                
                if let imageAdress = posts.first?.hdurl //confirmo que a publicacao tem hdurl
                    , let imageURL = URL(string: imageAdress) { //tenta transformar o texto em uma url
                    do {
                        let image = try await fetchImage(from: imageURL) //baixo os dados
                        apodImageView.image = image
                    } catch {
                        print("Falha ao carregar a imagem:", error)
                    }
                }
                
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
    
    private var isFavorite = false
    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
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
    
    private let imageContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let favoriteButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        
//        button.setTitle("botao", for: .normal)
//        button.layer.cornerRadius = 5
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.backgroundColor = UIColor.green.cgColor
//        button.tintColor = .systemCyan
        button.configuration = .glass()
        
        return button
    }()
    
    @objc
    private func tapFavoriteButton() {
        isFavorite.toggle()
        
        let symbolName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: symbolName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
    }
    
    private lazy var headerStackView = StackComponent(axis: .vertical,
                                                      arrangedSubViews:[titleLabel, dateLabel],
                                                      spacing: 4
    )
    
    private lazy var contentStackView = StackComponent(axis: .vertical,
                                                       arrangedSubViews: [headerStackView, imageContainerView],
                                                       spacing: 32
    )
    
    private func setupView() {
        view.backgroundColor = .white
//        view.addSubview(customView)
//        view.addSubview(button)
//        view.addSubview(headerStackView)
        imageContainerView.addSubview(apodImageView)
        imageContainerView.addSubview(favoriteButton)
        view.addSubview(contentStackView)
        
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.75),
            apodImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            apodImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            apodImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            apodImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            favoriteButton.topAnchor.constraint(equalTo: imageContainerView.topAnchor,constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8)
            
        ])
    }
    
}

#Preview {
    let controller = ViewController()
    controller.title = "Explorar"
    return UINavigationController(rootViewController: controller)
}


