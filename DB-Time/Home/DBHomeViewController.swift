//
//  DBHomeViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/3.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Moya
import ObjectMapper

class DBHomeViewController: DBBaseViewController, DBHomeLoadViewProtocol {
    
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var superLikeButton: UIButton!
    
//    private var swipeableView: ZLSwipeableView!
    // 当前card在数组中的索引
    private var currentCardIndex: Int = 0
    private var dataSource: [DBMovieSubject] = []
    private var detailVC = DBMovieDetailViewController()
    private var isShowing: Bool = false
    private var translation: CGPoint = .zero
    
    private var bottomButtons: [UIButton]!
    private var popListView = DBPopupMovieTypeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = COLOR_APPNORMAL
        navigationItem.title = "电影"
        
        let leftBarItemButton = UIButton(type: .system)
        leftBarItemButton.frame.size = CGSize(width: 50, height: 30)
        leftBarItemButton.setImage(#imageLiteral(resourceName: "Category"), for: .normal)
        leftBarItemButton.imageView?.contentMode = .scaleAspectFit
        leftBarItemButton.addTarget(self, action: #selector(leftBarButtonItemDidTap), for: .touchUpInside)
        leftBarItemButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItemButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightMoreButtonDidTap))
        //
//        passButton.clipCorners(corners: [.topRight, .bottomLeft], radius: 20)
//        likeButton.clipCorners(corners: [.topLeft, .bottomRight], radius: 20)
//        superLikeButton.clipCorners(corners: [.topLeft, .topRight], radius: 20)
        
        bottomButtons = [passButton, likeButton, superLikeButton]
        
        swipeableView.allowedDirection = [.horizontal, .up]
        swipeableView.numberOfActiveView = 3
        swipeableView.onlySwipeTopCard = true
        
        self.addChildViewController(detailVC)
        
        
        setupSwipeableViewDelegate()
        requestData()
        
//        swipeableView.didTap = {view, location in
//            guard let containerView = view as? DBMovieCardContainer, let cardView = containerView.card else { return }
//            guard let movie = cardView.cardMovie else { return }
//            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromLeft, animations: {
//                cardView.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi/2), 0, 1, 0)
//            }, completion: { (_) in
//                if cardView.subviews.contains(self.detailVC.view) {
//                    self.detailVC.view?.removeFromSuperview()
//                } else {
//                    self.detailVC.view.frame = cardView.bounds
//                    cardView.addSubview(self.detailVC.view)
//                    if self.detailVC.movieSubject?.id != movie.id {
//                        self.detailVC.movieSubject = movie
//                        self.detailVC.getMovieDetail(movie.id)
//                    }
//                }
//                UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromLeft, animations: {
//                    cardView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
//                })
//            })
//        }
//
//        swipeableView.didSwipe = { view, direction, vector in
//            guard let containerView = view as? DBMovieCardContainer, let cardView = containerView.card else { return }
//            if cardView.subviews.contains(self.detailVC.view) {
//                self.detailVC.view?.removeFromSuperview()
//            }
//        }
    }
    
    @IBAction func bottomButtonsAction(_ sender: UIButton) {
        switch sender {
        case passButton:
            self.swipeableView.swipeTopView(inDirection: .left)
        case likeButton:
            self.swipeableView.swipeTopView(inDirection: .right)
        default:
            self.swipeableView.swipeTopView(inDirection: .up)
        }
    }
    
    
    func requestData(_ index: Int = 0) {
        
        showLoadView()
        
        var api: DBNetworkAPI = .inTheaters
        switch index {
        case 0:
            api = .inTheaters
        case 1:
            api = .comingSoon
        case 2:
            api = .top250
        case 3:
            api = .usBox
        case 4:
            api = .newMovies
        default:
            break
        }
        self.currentCardIndex = 0
        self.dataSource.removeAll()
        
        if api.path == "/v2/movie/us_box" {
            DBNetworkProvider.rx.request(api)
                .mapObject(DBUSBox.self)
                .subscribe(onSuccess: { data in
                    // 数据处理

                    print(data)
                    self.dataSource = data.subjects.map({ $0.subject })
                    self.swipeableView.discardViews()
                    self.loadNextView()
                }, onError: { error in
                    print("数据请求失败! 错误原因: ", error)
                }).disposed(by: disposeBag)

        } else {
            DBNetworkProvider.rx.request(api)
                .mapObject(DBMovie.self)
                .subscribe(onSuccess: { data in
                    self.hideLoadView()
                    // 数据处理
                    print(data)
                    self.dataSource = data.subjects
                    self.swipeableView.discardViews()
                    self.loadNextView()
                }, onError: { error in
                    print("数据请求失败! 错误原因: ", error)
                }).disposed(by: disposeBag)
        }
        
    }
    
    func loadNextView() {
        
        swipeableView.nextView = {
            
            if self.currentCardIndex >= self.dataSource.count {
                return nil
            }
            let bounds = self.swipeableView.bounds
            let container = DBMovieCardContainer(frame: bounds)
            let card = DBMovieCardView.loadFromNibAndClass(DBMovieCardView.self)!
            container.addSubview(card)
            card.snp.makeConstraints() {
                $0.top.left.equalToSuperview()
                $0.size.equalTo(container.bounds.size)
            }
            container.card = card
            
            if self.currentCardIndex < self.dataSource.count {
                let model = self.dataSource[self.currentCardIndex]
                card.setupWithUser(movie: model)
                self.currentCardIndex += 1
            }
            return container
        }
    }
    
    @objc func leftBarButtonItemDidTap() {
        if self.menuContainerViewController.sideMenuState == .leftMenuOpen {
            self.menuContainerViewController.setSideMenuState(state: .closed)
        } else {
            self.menuContainerViewController.setSideMenuState(state: .leftMenuOpen)
        }
    }
    
    @objc func rightMoreButtonDidTap() {
    
        if view.subviews.contains(popListView) {
            popListView.dismiss()
        } else {
            view.addSubview(popListView)
            popListView.snp.makeConstraints({
                $0.edges.equalToSuperview()
            })
            popListView.backClosure = { row in
                self.requestData(row)
            }
            popListView.show()
        }
    }
}



// MARK: - SwipeableViewDelegate
extension DBHomeViewController {
    func setupSwipeableViewDelegate()  {
        
        /// Swiping at view location
        swipeableView.swiping = { view, location, translation in
//            guard let containerView = view as? DBMovieCardContainer, let cellView = containerView.card else { return }
            let limit: CGFloat = 30.0
            let distance = (SCREEN_WIDTH - 20 * 4) / 3 + 20
            
            if (translation.y < -limit * CGFloat(3)) {

            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    if (translation.x < -limit) {
                        self.likeButton.transform = CGAffineTransform(translationX: distance, y: 0)
                    } else if (translation.x > limit) {
                        self.passButton.transform = CGAffineTransform(translationX: -distance, y: 0)
                    }
                })
            }
            
            if (translation.y < 0 && abs(translation.x) < limit * CGFloat(2)) {
                UIView.animate(withDuration: 0.25, animations: {
                    self.likeButton.transform = CGAffineTransform(translationX: distance, y: 0)
                    self.passButton.transform = CGAffineTransform(translationX: -distance, y: 0)
                    self.superLikeButton.transform = .identity
                    self.bottomButtons.filter({ $0 != self.superLikeButton }).forEach({ $0.backgroundColor = UIColor.orange })
                    self.superLikeButton.backgroundColor = UIColor(r: 0, g: 172, b: 98)
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    if translation.x > 0 {
                        self.likeButton.transform = CGAffineTransform(translationX: -distance, y: 0)
                        self.bottomButtons.filter({ $0 != self.likeButton }).forEach({ $0.backgroundColor = UIColor.orange })
                        self.likeButton.backgroundColor = UIColor(r: 0, g: 172, b: 98)
                    } else {
                        self.passButton.transform = CGAffineTransform(translationX: distance, y: 0)
                        self.bottomButtons.filter({ $0 != self.passButton }).forEach({ $0.backgroundColor = UIColor.orange })
                        self.passButton.backgroundColor = UIColor(r: 0, g: 172, b: 98)
                    }
                    self.superLikeButton.transform = CGAffineTransform(translationX: 0, y: 50)
                })
            }
//            self.translation = translation
        }
        
        /// Did end swiping view at location:
//        swipeableView.didEnd = {view, location in
//            if (!self.didSwipe) {
//                if (self.translation.x <= -(UIScreen.main.bounds.width * 0.4)) {
//                    self.swipeableView.swipeTopView(inDirection: .left)
//                }
//
//                if (self.translation.x >= (UIScreen.main.bounds.width * 0.4)) {
//                    self.swipeableView.swipeTopView(inDirection: .right)
//                }
//
//                let limit: CGFloat = 30.0
//                if (self.translation.y < -limit * CGFloat(3) && (self.translation.x >= -limit * CGFloat(2)) && self.translation.x <= limit * CGFloat(2)) {
//                    self.swipeableView.swipeTopView(inDirection: .up)
//                }
//            }
//        }
        // Did swipe view in direction:  vector:
        swipeableView.didSwipe = { view, direction, vector in
            guard let containerView = view as? DBMovieCardContainer, let cardView = containerView.card else { return }
            if cardView.subviews.contains(self.detailVC.view) {
                self.detailVC.view?.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.superLikeButton.transform = .identity
                self.likeButton.transform = .identity
                self.passButton.transform = .identity
                
                self.bottomButtons.filter({ $0 != self.superLikeButton }).forEach({ $0.backgroundColor = UIColor.orange })
                self.superLikeButton.backgroundColor = UIColor(r: 0, g: 172, b: 98)
            })
        }
        
        /// Did cancel swiping view
        swipeableView.didCancel = {view in
            //print("Did cancel swiping view")
//            guard let containerView = view as? DBMovieCardContainer, let cardView = containerView.card else { return }
//            cardView.reset()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.superLikeButton.transform  = .identity
                self.likeButton.transform       = .identity
                self.passButton.transform       = .identity
                
                self.bottomButtons.filter({ $0 != self.superLikeButton }).forEach({ $0.backgroundColor = UIColor.orange })
                self.superLikeButton.backgroundColor = UIColor(r: 0, g: 172, b: 98)
            })
        }
        
        /// Did tap at location
        swipeableView.didTap = {view, location in
            guard let containerView = view as? DBMovieCardContainer, let cardView = containerView.card else { return }
            guard let movie = cardView.cardMovie else { return }
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromLeft, animations: {
                cardView.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi/2), 0, 1, 0)
            }, completion: { (_) in
                if cardView.subviews.contains(self.detailVC.view) {
                    self.detailVC.view?.removeFromSuperview()
                } else {
                    self.detailVC.view.frame = cardView.bounds
                    cardView.addSubview(self.detailVC.view)
                    if self.detailVC.movieSubject?.id != movie.id {
                        self.detailVC.movieSubject = movie
                        self.detailVC.getMovieDetail(movie.id)
                    }
                }
                UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromLeft, animations: {
                    cardView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
                })
            })
        }
    }
    
    // 回滚
    func rollback() {
        self.swipeableView.rewind()
//        let cellView = (self.swipeableView.topView() as! HHDatingCardContainer).card
//        cellView?.swipeToLeft(withAlpha: 0)
//        cellView?.swipeToRight(withAlpha: 0)
//        cellView?.swipeToUp(withAlpha: 1)
    }
}
