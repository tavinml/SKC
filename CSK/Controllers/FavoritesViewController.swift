//
//  FavoritesViewController.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 18/11/26.
//

import UIKit
import SwiftData



final class FavoritesViewController: UIViewController {
    
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) nao foi implementado")
    }
    
    private var favorites: [FavoriteAPOD] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Nenhuma publicação favoritada"
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func loadFavorites() {
        let descriptor = FetchDescriptor<FavoriteAPOD>(sortBy: [SortDescriptor(\FavoriteAPOD.date, order: .reverse)]) //descreve a consulta
        
        do {
            favorites = try modelContext.fetch(descriptor) //busca os objetos
            
            tableView.reloadData() //atualizo a tabela
            
            let isEmpty = favorites.isEmpty
            
            tableView.isHidden = isEmpty
            emptyStateLabel.isHidden = !isEmpty
            
        } catch {
            print("Não foi possível carregar os favoritos:", error)
        }
    }
    
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),

            tableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),

            emptyStateLabel.centerYAnchor.constraint(
                equalTo: safeArea.centerYAnchor
            ),

            emptyStateLabel.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            )
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "FavoriteCell")
    }
    
    
    
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        
        let favorite = favorites[indexPath.row]
        
        var content = UIListContentConfiguration.subtitleCell()
        content.text = favorite.title
        content.secondaryText = favorite.date
        content.textProperties.numberOfLines = 2
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

//#Preview("Com favorito") {
//    let configuration = ModelConfiguration(
//        isStoredInMemoryOnly: true
//    )
//
//    let container = try! ModelContainer(
//        for: FavoriteAPOD.self,
//        configurations: configuration
//    )
//
//    let sampleFavorite = FavoriteAPOD(
//        date: "2026-11-18",
//        title: "Exemplo de publicação astronômica",
//        hdurl: nil,
//        credit: "NASA"
//    )
//
//    container.mainContext.insert(sampleFavorite)
//
//    let controller = FavoritesViewController(
//        modelContext: container.mainContext
//    )
//
//    controller.title = "Favoritos"
//
//    return UINavigationController(
//        rootViewController: controller
//    )
//}
