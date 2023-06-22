//
//  MainVC.swift
//  2023/05/18
//
//  Created by MYONHYUP LIM on 2022/09/03.
//

import Foundation
import UIKit
import WebKit
import Photos
import RxSwift

class MainVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public static var mInstance:MainVC? = nil
    
    var viewModel:MainViewModelType? = nil
    
    @IBOutlet weak var webView: WKWebView!
    
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let downloadDataSource: FileDownloadDataSource = FileDownloadDataSourceImpl()
        let repository = FileDownloadRepositoryImpl(downloadDataSource: downloadDataSource)
        let usecase = FileDownloadUseCase(downloadRepository: repository)
        
        let remoteDataSource: RemoteDataSource = RemoteDataSourceImpl()
        let userRepository = UserRepositoryImpl(remoteDataSource: remoteDataSource)
        let userInfoUsesace = UserInfoUseCase(userRepository: userRepository)
        
        
        let locationRepository = LocationRepositoryImpl()
        let directionUsecase = DirectionUseCase(locationRepository: locationRepository)
        
        viewModel = MainViewModel(
            fileDownloadUsecase: usecase,
            userInfoUsecase: userInfoUsesace,
            directionUsecase: directionUsecase
        )
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let url = URL(string: Constants.WebViewUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        bindViewModel()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bindViewModel() {
        viewModel?.output.openShare
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] url in
                guard let self = self else { return }
                let activityViewController = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: nil
                )

                self.present(
                    activityViewController,
                    animated: true,
                    completion: nil
                )
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.openBioAuth
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.openBioAuth()
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.openUrlScheme
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] url in
                guard let self = self else { return }
                print("=====> Current UrlScheme : \(url)")
            })
            .disposed(by: disposeBag)
    }
    
    func openBioAuth() {
        let vc = BioAuthVC.instantiate()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
}

