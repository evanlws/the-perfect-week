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
    var timePreferences: TimePreferences?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        let goalCollectionViewNib = UINib(nibName: String(describing: GoalCollectionViewCell.self), bundle: nil)
        collectionView.register(goalCollectionViewNib, forCellWithReuseIdentifier: String(describing: GoalCollectionViewCell.self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goals = realm.objects(Goal.self)
        if let timePreferences = realm.objects(TimePreferences.self).first {
            if let weeklyDueDate = timePreferences.weeklyDueDate, let goals = goals {
                if weeklyDueDate < Date() {
                    for goal in goals {
                        try! realm.write {
                            goal.completed = false
                        }
                    }
                }
            }
        } else {
            timePreferences = TimePreferences()
            timePreferences?.weeklyDueDate = Date().nextSunday()
            try! realm.write {
                realm.add(timePreferences!)
            }
        }
        collectionView.reloadData()
    }
}

extension GoalsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (goals?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoalCollectionViewCell.self), for: indexPath) as? GoalCollectionViewCell else { return UICollectionViewCell() }

        if indexPath.row != goals?.count, let goal = goals?[indexPath.row] {
            cell.goalLabel.text = goal.name
            cell.goalLabel.textColor = goal.completed ? .green : .black
        } else {
            cell.goalLabel.text = "Add a goal"
            cell.goalLabel.textColor = UIColor.black
        }

        return cell
    }
}

extension GoalsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.row == goals?.count {
            let addGoalVC = AddGoalViewController()
            present(addGoalVC, animated: true) {
                self.collectionView.reloadData()
            }
//            let addGoalStoryboard = UIStoryboard(name: "AddGoal", bundle: nil)
//            if let addGoalViewController = addGoalStoryboard.instantiateInitialViewController() {
//                present(addGoalViewController, animated: true) {
//                    self.collectionView.reloadData()
//                }
//            }
        } else {
            if let goal = goals?[indexPath.row] {
                do {
                    defer {
                        collectionView.reloadData()
                    }
                    try realm.write {
                        goal.completed = true
                    }
                } catch {
                    print("Could not update")
                }
            }
        }

    }
}
