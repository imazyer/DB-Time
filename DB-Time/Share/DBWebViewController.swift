//
//  DBWebViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/12.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import WebKit

class DBWebViewController: UIViewController {

    var url: String? = "https://movie.douban.com/celebrity/1274224/mobile"
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "周冬雨"
        
        setupViews()
        
        guard let urlString = url else { return }
        self.webView.load(URLRequest(url: URL(string: urlString)!))
    }
    
//    deinit {
//        self.webView.removeObserver(self, forKeyPath: estimatedProgressKeyPath)
//    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        self.webView = WKWebView()
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.allowsBackForwardNavigationGestures = true
        let backSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(backSwipeGestureAction))
        backSwipeGesture.direction = .right
        self.webView.scrollView.delegate = self
        self.webView.addGestureRecognizer(backSwipeGesture)
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        self.view.addSubview(webView)
        webView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    @objc func backSwipeGestureAction() {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension DBWebViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
