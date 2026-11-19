//
//  ViewController.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 09/11/26.
//

import UIKit
import SwiftData

class ViewController: UIViewController {
    
    private var isFavorite = false
    private var currentAPOD: APOD? //precisa ser opcional pois precisa esperar a consulta da api
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder) nao foi implementado")
    }
    

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
                
                guard let apod = posts.first else {
                    titleLabel.text = "Nenhuma publicação encontrada"
                    return
                }
                
                print("APOD:", apod.title)
                print("APOD:", apod.date)
                
                await updateScreen(with: apod)
                    
                
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
    
    
    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
        choseDataButton.addTarget(self, action: #selector(tapChooseDateButton), for: .touchUpInside)
        randomDataButton.addTarget(self, action: #selector(tapRandomDataButton), for: .touchUpInside)
    }
    
    private func updateScreen(with apod: APOD) async {
        currentAPOD = apod //para conseguir guardar o objeto que será recebido
        updateFavoriteState(for: apod)
        
        titleLabel.text = apod.title
        dateLabel.text = apod.date
        
        if let credit = apod.credit {
            let plainCredit = credit.htmlToPlainText
            creditsLabel.text = "Créditos: \(plainCredit)"
        } else {
            creditsLabel.text = "Créditos não informados"
        }
        
        apodImageView.image = UIImage(systemName: "photo")
        
        if let imageAdress = apod.hdurl //confirmo que a publicacao tem hdurl
            , let imageURL = URL(string: imageAdress) { //tenta transformar o texto em uma url
            do {
                let image = try await fetchImage(from: imageURL) //baixo os dados
                apodImageView.image = image
            } catch {
                print("Falha ao carregar a imagem:", error)
            }
        }
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
    
    private let creditsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Créditos:"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
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
    
    private let choseDataButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        configuration.title = "Escolher data"
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let randomDataButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        configuration.title = "Data aleatória"
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func updateFavoritesButtonApearence() {
        let symbolName = isFavorite ? "heart.fill" : "heart"
        
        favoriteButton.setImage(UIImage(systemName: symbolName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
    }
    
    private func updateFavoriteState(for apod: APOD) {
        do {
            isFavorite = try findFavorite(for: apod) != nil
        } catch {
            isFavorite = false
            print("Não foi possivel consultar o favorito", error)
        }
        
        updateFavoritesButtonApearence()
    }
    
    @objc
    private func tapFavoriteButton() {
        guard let currentAPOD else {
            return
        } //preciso fazer isso pois a tela aparece antes da API carregar
        
        do {
            //caso a busca encontre uma publicacao, ela já é salva
            if let savedFavorite = try findFavorite(for: currentAPOD) {
                modelContext.delete(savedFavorite)
                isFavorite = false
            } else {
                let favorite = FavoriteAPOD(date: currentAPOD.date,
                                            title: currentAPOD.title,
                                            hdurl: currentAPOD.hdurl,
                                            credit: currentAPOD.credit)
                
                modelContext.insert(favorite)
                isFavorite = true
            }
            
            try modelContext.save()
            updateFavoritesButtonApearence()
        } catch {
            print("Não foi possível alterar o favorito", error)
        }
    }
    
    @objc
    private func tapChooseDateButton() {
        let datePickerController = DatePickerController()
        datePickerController.title = "Escolher data"
        
        datePickerController.onDateSelected = { [weak self] selectedDate in
            guard let self else { // verifica se a viewController ainda existe
                return
            }
            
            Task { //precisa ser uma task pois a consulta é async
                do {
                    self.titleLabel.text = "Carregando publicação"
                    
                    let apod = try await fetchAPOD(for: selectedDate) //envia a data para o serviço e devolve um APOD
                    
                    await self.updateScreen(with: apod) //faz a atualização do título, data, imagem e créditos
                } catch {
                    print("Falha ao buscar a data escolhida:", error)
                    self.titleLabel.text = "Não foi possível carregar a publicação"
                }
            }
            
        }
        
        let navigationController = UINavigationController(rootViewController: datePickerController)
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [
                .medium(),
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        present(navigationController,
                animated: true)
    }
    
    @objc
    private func tapRandomDataButton() {
        let calendar = Calendar.current
        
        //data que o APOD foi criado
        let startComponents = DateComponents(year: 1995,
                                             month: 6,
                                             day: 16)
        
        //para conseguir representar uma data
        guard let startDate = calendar.date(from: startComponents) else {
            return
        }
        
        //representar a quantidade de segundas desde 1970 e transformamos em numero
        let startTime = startDate.timeIntervalSince1970
        let currentTime = Date().timeIntervalSince1970
        
        //fazendo o sorteio
        let randomTime = TimeInterval.random(in: startTime...currentTime)
        
        //usando o numero sorteado e transformando em uma data
        let randomDate = Date(timeIntervalSince1970: randomTime)
        
        Task {
            do {
                titleLabel.text = "Carregando publicação"
                
                let apod = try await fetchAPOD(for: randomDate)
                
                await updateScreen(with: apod)
                
            } catch {
                print("Falha ao buscar uma data aleatória:", error)
                titleLabel.text = "Não foi possível carregar a publicação"            }
        }
        
    }
    

    
    private lazy var headerStackView = StackComponent(axis: .vertical,
                                                      arrangedSubViews:[titleLabel, dateLabel],
                                                      spacing: 4
    )
    
    private lazy var contentStackView = StackComponent(axis: .vertical,
                                                       arrangedSubViews: [headerStackView, mediaStackView, actionsStackView],
                                                       spacing: 32
    )
    
    private lazy var mediaStackView = StackComponent(axis: .vertical,
                                                     arrangedSubViews: [imageContainerView, creditsLabel],
                                                     spacing: 8)
    private lazy var actionsStackView = StackComponent(axis: .horizontal,
                                                       arrangedSubViews: [choseDataButton, randomDataButton],
                                                       spacing: 16)
    
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
    
    private func findFavorite(for apod: APOD) throws -> FavoriteAPOD? {
        let apodDate = apod.date
        
        //descreve o que tem que ser buscado, ou seja, um objeto FavoriteAPOD
        let descriptor = FetchDescriptor<FavoriteAPOD>(predicate: #Predicate { favorite in  favorite.date == apodDate //predicate funciona como um filtro de a data do favorito ser igual a data do apod atual
    
            }
        )
        
        return try modelContext.fetch(descriptor).first
    }

    
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

    let container = try! ModelContainer(for: FavoriteAPOD.self, configurations: configuration
    )

    let controller = ViewController(modelContext: container.mainContext)

    controller.title = "Explorar"

    return UINavigationController(rootViewController: controller)
}


