//
//  TypealiasClass.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 19/05/24.
//

import Foundation

//typealias TableViewDelegateAndDataSource = (UITableViewDelegate,UITableViewDataSource)
//typealias CollectionViewDelegateAndDataSource = (UICollectionViewDelegate,UICollectionViewDataSource)
// Define a protocol that inherits from both UITableViewDelegate and UITableViewDataSource
protocol TableViewDelegateAndDataSource: UITableViewDelegate, UITableViewDataSource {}

// Define a protocol that inherits from both UICollectionViewDelegate and UICollectionViewDataSource
protocol CollectionViewDelegateAndDataSource: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {}
