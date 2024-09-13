import UIKit
import SDWebImage
import FirebaseAuth

class AdoptionsViewController: UIViewController {
    
    @IBOutlet weak var adoptionsView: UICollectionView!
    
    let dataService = DataService.dataService
    
    private var selectedAnimal: AnimalAdoption?
    var adoptions = [AnimalAdoption]()
    var currentUser: AppUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adoptionsView.delegate = self
        adoptionsView.dataSource = self
        
        adoptionsView.register(UINib(nibName: Constants.adoptionCellName, bundle: nil), forCellWithReuseIdentifier: Constants.adoptionsCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAdoptions()
        fetchCurrentUser()
    }
    
    private func fetchAdoptions() {
        dataService.getAdoptions { [weak self] adoptions in
            DispatchQueue.main.async {
                self?.adoptions = adoptions ?? []
                self?.adoptionsView.reloadData()
            }
        }
    }
    
    private func fetchCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        dataService.loadUser(byID: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.currentUser = result
                self?.adoptionsView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.petProfileSegue {
            let destinationVc = segue.destination as! PetProfileViewController
            
            destinationVc.adoption = selectedAnimal
        }
    }
}

extension AdoptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adoptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.adoptionsCell, for: indexPath) as! AdoptionsCollectionViewCell
        
        let adoption = adoptions[indexPath.item]
        
        cell.animalName?.text = adoption.animalName
        cell.ageLabel.text = adoption.animalAge.getFormattedAge
        
        if let isFavourite = currentUser?.favouritePosts.first(where: {$0 == adoption.adoptionId}) {
            cell.heartImage.image = UIImage(systemName: "heart.fill")
        } else {
            cell.heartImage.image = UIImage(systemName: "heart")
        }
        
        if let url = URL(string: adoption.photoUrl ?? "") {
            cell.animalImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAnimal = adoptions[indexPath.row]
        
        self.performSegue(withIdentifier: Constants.petProfileSegue, sender: self)
    }
}
