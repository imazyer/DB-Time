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

class DBHomeViewController: DBBaseViewController {
    
    private var swipeableView: ZLSwipeableView!
    // 当前card在数组中的索引
    private var currentCardIndex: Int = 0
    private var dataSource: [DBMovieSubject] = []
    private var detailVC = DBMovieDetailViewController()
    private var isShowing: Bool = false
    let popListView = DBPopupMovieTypeView()
    
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
        
        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)
        swipeableView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-100)
        })
        
        swipeableView.allowedDirection = [.horizontal, .up]
        swipeableView.numberOfActiveView = 3
        swipeableView.onlySwipeTopCard = true

        self.addChildViewController(detailVC)
        
//        setupSwipeableViewDelegate()
        requestData()
        
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
        
        swipeableView.didSwipe = { view, direction, vector in
            guard let containerView = view as? DBMovieCardContainer, let cardView = containerView.card else { return }
            if cardView.subviews.contains(self.detailVC.view) {
                self.detailVC.view?.removeFromSuperview()
            }
        }
    }
    
    func requestData(_ index: Int = 0) {
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
/*
extension DBHomeViewController {
    func setupSwipeableViewDelegate()  {
        
        /// Swiping at view location
        swipeableView.swiping = { view, location, translation in
            let cellView = view as! HHDatingCardContainer
            let limit: CGFloat = 30.0
            if (translation.y < -limit * CGFloat(3)) {
                if (translation.x < -limit * CGFloat(2)) {
                    let alpha = min(1.0, (abs(translation.x) - limit * CGFloat(2)) / limit)
                    cellView.swipeToLeft(withAlpha: alpha)
                } else if (translation.x > limit * CGFloat(2)) {
                    let alpha = min(1.0, (abs(translation.x) - limit * CGFloat(2)) / limit)
                    cellView.swipeToRight(withAlpha: alpha)
                } else {
                    let alpha = min(1.0, (abs(translation.y) - limit * CGFloat(3)) / limit)
                    cellView.swipeToUp(withAlpha: alpha)
                }
            } else {
                cellView.swipeToUp(withAlpha: 0.0)
                if (translation.x < -limit) {
                    let alpha = min(1.0, (abs(translation.x) - limit) / limit)
                    cellView.swipeToLeft(withAlpha: alpha)
                } else if (translation.x > limit) {
                    let alpha = min(1.0, (abs(translation.x) - limit) / limit)
                    cellView.swipeToRight(withAlpha: alpha)
                }
            }
            
            if (translation.y < 0 && abs(translation.x) < limit * CGFloat(2)) {
                let scaleY = 1.0 + min(abs(translation.y), 100) * 0.002
                UIView.animate(withDuration: 0.25, animations: {
                    self.superLikeButton.transform = CGAffineTransform(scaleX: scaleY, y: scaleY)
                    self.likeButton.transform = .identity
                    self.passButton.transform = .identity
                })
            } else {
                let scaleX = 1.0 + min(abs(translation.x), 100) * 0.002;
                UIView.animate(withDuration: 0.25, animations: {
                    if translation.x > 0 {
                        self.likeButton.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
                    } else {
                        self.passButton.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
                    }
                    self.superLikeButton.transform = .identity
                })
            }
            self.translation = translation
        }
        
        /// Did end swiping view at location:
        swipeableView.didEnd = {view, location in
            if (!self.didSwipe) {
                if (self.translation.x <= -(UIScreen.main.bounds.width * 0.4)) {
                    self.swipeableView.swipeTopView(inDirection: .left)
                }
                
                if (self.translation.x >= (UIScreen.main.bounds.width * 0.4)) {
                    self.swipeableView.swipeTopView(inDirection: .right)
                }
                
                let limit: CGFloat = 30.0
                if (self.translation.y < -limit * CGFloat(3) && (self.translation.x >= -limit * CGFloat(2)) && self.translation.x <= limit * CGFloat(2)) {
                    self.swipeableView.swipeTopView(inDirection: .up)
                }
            }
            
            self.didSwipe = false
        }
        // Did swipe view in direction:  vector:
        swipeableView.didSwipe = {view, direction, vector in
            
            let cellView = view as! HHDatingCardContainer
            
            guard let user = cellView.card?.user else {
                self.rollback()
                return
            }
            self.didSwipe = true
            
            switch direction {
            case .left:
                self.passWithUserID(user.id)
            case .right:
                self.likeWithUserID(user)
            case .up:
                if !self.isSuperLike {
                    self.rollback()
                    let coverView: HHSuperLikeCoverView = HHSuperLikeCoverView.coverView()
                    coverView.updateUI(user: user, iconImage: cellView.card?.pictureImageView.image)
                    coverView.outOfBalance = { [weak self] in
                        let pGoldVC = R.storyboard.mine.hhPurchaseGoldViewController()!
                        self?.navigationController?.pushViewController(pGoldVC, animated: true)
                    }
                    coverView.sendBarSuccess = { [weak self] model, count, outOfChance in
                        cellView.card?.updateUIWithSuperLike()
                        self?.startSuperLikeStarAnimation()
                        executeAfterDelay(1, closure: {
                            self?.isSuperLike = true
                            self?.swipeableView.swipeTopView(inDirection: .up)
                            if model?.isMatched == true {
                                let matchedView = HHMatchSuccessView.matchView()
                                matchedView.showWithUser(user)
                                matchedView.beginChatClosure = {
                                    self?.startConversation(with: user)
                                }
                                return
                            }
                            if outOfChance {
                                executeAfterDelay(1, closure: {
                                    self?.showOutOfChancesView()
                                })
                            }
                        })
                    }
                    coverView.coverViewDismissed = {
                        cellView.swipeToUp(withAlpha: 0)
                    }
                    coverView.show()
                }
                self.isSuperLike = false
            default:
                break
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.superLikeButton.transform = .identity
                self.likeButton.transform = .identity
                self.passButton.transform = .identity
            })
            
            self.currentIndex = 0
            if self.swipeableView.activeViews().count <= 0 {
                log.debug("重新请求数据")
                self.checkAndGetLocation()
            }
        }
        /// Did cancel swiping view
        swipeableView.didCancel = {view in
            //print("Did cancel swiping view")
            let cellView = view as! HHDatingCardContainer
            cellView.reset()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.superLikeButton.transform  = .identity
                self.likeButton.transform       = .identity
                self.passButton.transform       = .identity
            })
        }
        
        /// Did tap at location
        swipeableView.didTap = {view, location in
            
            let cellView = view as! HHDatingCardContainer
            guard let userModel = cellView.card?.user else {
                return
            }
            
            let infoVC = R.storyboard.home.hhUserInfoViewController()!
            infoVC.profileModel = userModel
            let navi = HHBaseNavigationController(rootViewController: infoVC)
            navi.hero.isEnabled = true
            infoVC.prevType = .other
            infoVC.backClosure = { index in
                if self.currentIndex == index { return }
                self.currentIndex = index
                if let cardContainer = self.swipeableView.topView() as? HHDatingCardContainer, let topView = cardContainer.card {
                    let medias = userModel.profileMedias
                    if index < medias.count {
                        topView.updateMediaImageView(media: medias[index])
                    }
                }
            }
            
            infoVC.reloadActiveViewsClosure = {
                self.reloadActiveViewsData()
            }
            
            infoVC.backClosureWithAction = { [weak self] matchModel, direction, outOfChance in
                switch direction {
                case .left:
                    self?.bottomButtonClickAction((self?.passButton)!)
                case .right:
                    self?.bottomButtonClickAction((self?.likeButton)!)
                case .up:
                    cellView.card?.updateUIWithSuperLike()
                    self?.startSuperLikeStarAnimation()
                    if matchModel?.isMatched == true {
                        let matchedView = HHMatchSuccessView.matchView()
                        matchedView.showWithUser(userModel)
                        matchedView.beginChatClosure = {
                            self?.startConversation(with: userModel)
                        }
                        return
                    }
                    executeAfterDelay(1, closure: {
                        self?.isSuperLike = true
                        self?.swipeableView.swipeTopView(inDirection: .up)
                        
                        if outOfChance {
                            executeAfterDelay(1, closure: {
                                self?.showOutOfChancesView()
                            })
                        }
                    })
                default:
                    break
                }
            }
            infoVC.currentIndex = self.currentIndex
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    // 回滚
    func rollback() {
        self.swipeableView.rewind()
        let cellView = (self.swipeableView.topView() as! HHDatingCardContainer).card
        cellView?.swipeToLeft(withAlpha: 0)
        cellView?.swipeToRight(withAlpha: 0)
        cellView?.swipeToUp(withAlpha: 1)
    }
}
 */
