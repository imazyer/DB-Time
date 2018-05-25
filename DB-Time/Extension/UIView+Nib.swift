//
//  UIView+Nib.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

// MARK: - UITableView from nib
extension UITableView {
    
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T : UITableViewCell>(with cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cell.self), for: indexPath) as! T
    }
    
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T : UITableViewCell>(with cell: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cell.self)) as! T
    }
    
    /// Returns a reusable header or footer view located by its identifier.
    /// Note: withIdentifier must be equal to the View Class.
    func dequeueReusableHeaderFooterView<T : UITableViewHeaderFooterView>(with view: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: view.self)) as! T
    }
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// Nib name must be equal to the Cell Class, and the forCellReuseIdentifier must equal to Cell Class as well.
    func registerNib(_ cellClass: Swift.AnyClass) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }
    
    /// Registers a class for use in creating new table cells.
    /// Note: forCellReuseIdentifier must equal to the Cell Class.
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }
    
    /// Registers a class for use in creating new table header or footer views.
    /// Note: forHeaderFooterViewReuseIdentifier must equal to the UITableViewHeaderFooterView Class.
    func registerHeaderFooterViewClass(_ headerFooterViewClass: Swift.AnyClass) {
        register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterViewClass.self))
    }
    
    /// Registers a nib object containing a header or footer with the table view under a specified identifier.
    /// Nib name must be equal to the UITableViewHeaderFooterView Class, and the forHeaderFooterViewReuseIdentifier must equal to UITableViewHeaderFooterView Class as well.
    func registerHeaderFooterViewNib(_ headerFooterViewClass: Swift.AnyClass) {
        let id = String(describing: headerFooterViewClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: id)
    }
}


// MARK: - UICollectionView form nib
extension UICollectionView {
    
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T : UICollectionViewCell>(with cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as! T
    }
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// Nib name must be equal to the Cell Class, and the forCellReuseIdentifier must equal to Cell Class as well.
    func registerNib(_ cellClass: Swift.AnyClass) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellWithReuseIdentifier: id)
    }
    
    /// Registers a class for use in creating new table cells.
    /// Note: forCellReuseIdentifier must equal to the Cell Class.
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
    
    func registerHeaderViewNib(_ header: Swift.AnyClass) {
        let id = String(describing: header.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: id)
    }
    
    func registerFooterViewNib(_ footer: Swift.AnyClass) {
        let id = String(describing: footer.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: id)
    }
    
    func dequeueReusableHeader<T : UIView>(with view: T.Type, for indexPath: IndexPath) -> T {
        let id = String(describing: view.self)
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: id, for: indexPath) as! T
    }
    
    func dequeueReusableFooter<T : UIView>(with view: T.Type, for indexPath: IndexPath) -> T {
        let id = String(describing: view.self)
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: id, for: indexPath) as! T
    }
}



// MARK: - load view form nib
extension UIView {
    
    /// Load view from nib. Note: Nib name must be equal to the class name.
    ///
    /// - parameter view:    The name of the nib file, which need not include the .nib extension
    /// - parameter owner:   The object to assign as the nib’s File's Owner object
    /// - parameter options: options
    ///
    /// - returns: view
    class func loadFromNibAndClass<T : UIView>(_ view: T.Type, owner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T? {
        let name = String(describing: view.self)
        guard let nib = Bundle.main.loadNibNamed(name, owner: owner, options: options) else { return nil }
        return nib.first as? T
    }
}
