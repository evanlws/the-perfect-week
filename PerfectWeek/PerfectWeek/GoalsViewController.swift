//
//  GoalsViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/19/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit
import RealmSwift

class GoalsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var goals: Results<Goal>?

    override func viewDidLoad() {
        super.viewDidLoad()

        let goalCollectionViewNib = UINib(nibName: String(describing: GoalCollectionViewCell.self), bundle: nil)
        collectionView.register(goalCollectionViewNib, forCellWithReuseIdentifier: String(describing: GoalCollectionViewCell.self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let realm = try! Realm()
        goals = realm.objects(Goal.self)
    }

}

extension GoalsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (goals?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoalCollectionViewCell.self), for: indexPath) as? GoalCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row != goals?.count {
            cell.goalLabel.text = goals?[indexPath.row].name
        }

        return cell
    }
}

extension GoalsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addGoalStoryboard = UIStoryboard(name: "AddGoal", bundle: nil)
        if let addGoalViewController = addGoalStoryboard.instantiateInitialViewController() {
            present(addGoalViewController, animated: true) {
                self.collectionView.reloadData()
            }
        }
    }
}
