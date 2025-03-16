//
//  UITableViewMock.swift
//  image FeedTests
//
//  Created by Николай Жирнов on 07.03.2025.
//

import UIKit

class UITableViewMock: UITableView {
    var indexPathToReturn: IndexPath?
    
    override func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return indexPathToReturn
    }
}
