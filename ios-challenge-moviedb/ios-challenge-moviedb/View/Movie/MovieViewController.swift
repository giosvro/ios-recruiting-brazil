//
//  MovieCollectionViewController.swift
//  ios-challenge-moviedb
//
//  Created by Giovanni Severo Barros on 22/02/20.
//  Copyright © 2020 Giovanni Severo Barros. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {
    
    var presenter: MoviePresenter?
    
    private var estimatedCellWidth: CGFloat = Constants.MovieCollectionView.estimatedCellWidth
    private var cellMargin: CGFloat = Constants.MovieCollectionView.cellMargin
    
    var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: Constants.MovieCollectionView.cellMargin,
                                           left: 7,
                                           bottom: Constants.MovieCollectionView.cellMargin,
                                           right: 7)
        layout.minimumLineSpacing = Constants.MovieCollectionView.cellMargin
        layout.minimumInteritemSpacing = Constants.MovieCollectionView.cellMargin
        layout.estimatedItemSize = CGSize(width: Constants.MovieCollectionView.estimatedCellWidth,
                                          height: Constants.MovieCollectionView.estimatedCellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Constants.MovieCollectionView.cellId)
        
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = MoviePresenter(viewController: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: - Loads Movies Data
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.loadCollectionView(page: 1)
         }
        print("ViewWillAppeal: ", presenter?.movies)
    }
    
    override func viewDidLoad() {
        setupUI()
        self.movieCollectionView.reloadData()
        
        print("viewDidLoad: ", presenter?.movies)

    }
    
    func setupUI() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        self.view.backgroundColor = .red
        self.view.addSubview(movieCollectionView)
        setupConstaints()
    }
    
    func setupConstaints() {
        // MARK: - Collection View Constraints
        movieCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidth()
        return CGSize(width: width, height: width*1.5)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = self.estimatedCellWidth
        let cellCount = floor(CGFloat(UIScreen.main.bounds.size.width / estimatedWidth))
        let margin = CGFloat(self.cellMargin * 2)
        let width = ((self.view.frame.size.width - cellMargin * cellCount - 1) - margin) / cellCount
        
        return width
    }
}

extension MovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfMovies ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.MovieCollectionView.cellId, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Wrong Cell ID")
        }
        
        if let movies = presenter?.movies {
            cell.movieImage.kf.indicatorType = .activity
            let movie = movies[indexPath.item]
            print("Title: ", movie.title)
            let moviePosterImageURL = presenter?.getMovieImageURL(width: 200, path: movie.posterPath)
            cell.movieImage.kf.setImage(with: moviePosterImageURL) { result in
                switch result {
                case .failure(let error): print("Não foi possivel carregar a imagem:", error.localizedDescription)
                    // Tratar o error
                default: break
                    
                }
            }
        } else {
            // Tratar o erro
        }
        return cell
    }
}

extension MovieViewController: MovieViewPresenterDelegate {
    func selectedMovie(movie: Movie) {
        
    }
}

