//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Rswift

extension UICollectionView {
    public func deque<Identifier>(_ identifier: Identifier, for indexPath: IndexPath) -> Identifier.ReusableType where Identifier : ReuseIdentifierType, Identifier.ReusableType : UICollectionReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) else {
            fatalError("Cannot deque cell with \(identifier)")
        }

        return cell
    }
}

extension UITableView {
    public func deque<Identifier>(_ identifier: Identifier, for indexPath: IndexPath) -> Identifier.ReusableType where Identifier : ReuseIdentifierType, Identifier.ReusableType : UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) else {
            fatalError("Cannot deque cell with \(identifier)")
        }

        return cell
    }
}
