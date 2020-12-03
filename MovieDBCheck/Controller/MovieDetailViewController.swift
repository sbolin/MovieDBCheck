//
//  MovieDetailViewController.swift
//  PopcornSwirl
//
//  Created by Scott Bolin on 11/7/20.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieActor: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieCompany: UILabel!
    
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieAverageScore: UILabel!
    @IBOutlet weak var movieVoteCount: UILabel!
    
    @IBOutlet weak var movieNotes: UITextField!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var watchedButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    //MARK: - Properties
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    var movieCollections = MovieDataController()
    var movie: MovieDataController.MovieItem?
    let formatter = DateFormatter()
    
    var actors: [String] = []
    var director: String = ""
    var companies: [String] = []
    var mainImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies"//"\(movie.title)"
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup(movie: movie!)
    }
    
    // called from MovieCollectionViewController prior to segue
    func setup(movie: MovieDataController.MovieItem) {
        // get actor and image for movie
        let posterURL = movieCollections.getImageURL(imageSize: "w780", endPoint: movie.posterPath)
        self.group.enter()
        MovieServiceAPI.shared.getMovieImage(imageURL: posterURL) { (success, image) in
            if success, let image = image {
                self.mainImage = image
            } // success
            self.group.leave()
        } // getMovieImage
        
        let actorURL = movieCollections.getCastURL(movieID: movie.id)
        self.group.enter()
        MovieServiceAPI.shared.getMovieCast(castURL: actorURL) { (success, cast) in
            if success, let cast = cast {
                self.actors = cast.actor
                self.director = cast.director
            } // success
            self.group.leave()
        } // getMovieCast
        
        let companyURL = movieCollections.getCompanyURL(movieID: movie.id)
        self.group.enter()
        MovieServiceAPI.shared.getMovieCompany(companyURL: companyURL) { (success, company) in
            if success, let company = company {
                self.companies = company.company
            } // success
            self.group.leave()
        } // getMovieCompany
        
        formatter.dateFormat = "yyyy"
        group.notify(queue: queue) { [self] in
            DispatchQueue.main.async { [self] in
                
                self.heroImage.image = self.mainImage
                self.movieTitle.text = movie.title
                self.movieYear.text = self.formatter.string(from: movie.releaseDate)
                self.movieOverview.text = movie.overview
                self.movieActor.text = self.actors.joined(separator: ", ")
                self.movieDirector.text = self.director
                self.movieCompany.text = self.companies.joined(separator: ", ")
                
                self.movieRating.text = "Rating: " + String(movie.popularity)
                self.movieAverageScore.text = "Score: " + String(movie.voteAverage)
                self.movieVoteCount.text = "Count: " + String(movie.voteCount)

                print("in moviedetailviewcontroller")
                print("movie passed in: \(movie)")
                print("movie title: \(movie.title)")
                print("backcrop image: \(movie.backdropImage)")
                print("poster image: \(movie.posterImage)")
                let releaseDate = formatter.string(from: movie.releaseDate)
                print("release data: \(releaseDate)")
                print("overview: \(movie.overview)")
                print("actors: \(movie.actor)")
                print("director: \(movie.director)")
                print("popularity: \(movie.popularity)")
                print("vote average: \(movie.voteAverage)")
                print("vote count: \(movie.voteCount)")
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func buyTapped(_ sender: UIButton) {
        print("buyTapped")
        buyButton.isSelected.toggle()
        changeAlpha(sender: sender)
    }
    
    @IBAction func watchTapped(_ sender: UIButton) {
        print("watchTapped")
        watchedButton.isSelected.toggle()
        changeAlpha(sender: sender)
    }
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        print("bookmarkTapped")
        bookmarkButton.isSelected.toggle()
        changeAlpha(sender: sender)
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        print("favoriteTapped")
        favoriteButton.isSelected.toggle()
        changeAlpha(sender: sender)
    }
    
    func changeAlpha(sender: UIButton) {
        if sender.isSelected {
            sender.alpha = 1.0
        } else {
            sender.alpha = 0.25
        }
    }
}
