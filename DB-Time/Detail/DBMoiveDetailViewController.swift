//
//  DBMoiveDetailViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/5.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DBMoiveDetailViewController: DBBaseViewController {

    private var tableView: UITableView!
    private var headerView = UIView.loadFromNibAndClass(DBMovieDetailHeaderView.self)!
    
    var movieSubject: DBMovieSubject?
    
    func bindData(_ movie: DBMovieSubject?) {
        guard let movie = movie else { return }
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        movieSubject = movie
        headerView.setupWithImage(movie.images)
        
        let items = Observable.just([
            SectionModel(model: "", items: [movie]),
            SectionModel(model: "", items: [movie]),
            SectionModel(model: "剧情简介:", items: [movie])
            ])
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DBMovieSubject>>(configureCell: {
            (dataSource, tableView, indexPath, movie) in
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(with: DBMovieInfoViewCell.self)
                cell.configWithMovie(movie)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(with: DBMovieMembersViewCell.self)
                let directors = movie.directors.map({ (model) -> DBCastModel in
                    model.role = "导演"
                    return model
                })
                cell.avatarClickClosure = { button, index in
                    button.superview?.subviews.forEach({ $0.hero.id = nil })
                    let castVC = DBCastViewController()
                    // hero
                    castVC.hero.isEnabled = true
                    self.navigationController?.hero.isEnabled = true
                    self.navigationController?.hero.navigationAnimationType = .fade
                    
                    let model = (directors + movie.casts)[index]
                    castVC.castModel = model
                    button.hero.id = "avatar_id\(model.id)"
                    self.navigationController?.pushViewController(castVC, animated: true)
                }
                cell.configWithCasts(directors + movie.casts)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(with: DBMovieSummaryCell.self)
                cell.configWithText(movie.summary)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.registerNib(DBMovieInfoViewCell.self)
        tableView.register(DBMovieSummaryCell.self)
        tableView.registerNib(DBMovieMembersViewCell.self)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = 0.001
        tableView.showsVerticalScrollIndicator = false
    
        view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        tableView.tableHeaderView = headerView
    }
}

extension DBMoiveDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 35 : 0.001
    }
}




