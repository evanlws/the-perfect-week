//
//  GoalsViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/19/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

}

extension GoalsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        return cell
    }
}

extension GoalsViewController: UICollectionViewDelegate {

}
