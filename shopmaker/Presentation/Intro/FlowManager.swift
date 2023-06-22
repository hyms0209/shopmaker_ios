


import Foundation
import UserNotifications
import UIKit
import Moya

/*
 * 초기 프로세스 처리
 *
 */

enum TaskFlow: Int {
    case netCheck           = 0    // 네트워크 체크
    case appemgNotice       = 1    // 긴급시스템 공지
    case appUpdate          = 2    // 앱업데이트
    case permission         = 3    // 권한동의
    case main               = 4    // 메인
}

protocol FlowManageDelegate {
    func onCancel(_ sender: TaskFlow)
    func onNext(_ sender: TaskFlow, param: [String: Any]?)
}

class FlowManager: FlowManageDelegate {
    
    deinit {
        print("FlowManager deinit!!!")
    }
    
    var context:UIViewController?
    
    var queue:[TaskFlow] = []
    
    init(viewcontroller:UIViewController) {
        context = viewcontroller
    }
    
    /**
     * 플로우 큐의 초기화( 타스크 진행 순서대로 추가 )
     * @param nil
     * @returns nil
     */
    func taskItem() {
        
        // 큐에 진행할 플로우 추가
        queue.removeAll()
        queue.append(.netCheck)
        queue.append(.appemgNotice)
        queue.append(.appUpdate)
        queue.append(.permission)
        queue.append(.main)
    }
    
    /**
     * 플로우 큐의 아이템 취득 ( init에 쌓은 순서 )
     * @param   nil
     * @returns nil
     */
    func nextTask() -> TaskFlow {
        let task = queue.first
        return task!
    }
    
    
    /**
     * 플로우 매니저 시작
     * @param
     * @returns
     */
    func start() {
        taskItem()
        runFlow(task: nextTask(), param:nil)
    }
    
    /**
     * 실제 기능을 실행
     * @param
     * @returns
     */
    func runFlow(task:TaskFlow, param:[String:Any]?) {
        print("=====> RUN TASK : \(task)")
        switch task {
        case .netCheck:                         // 네트워크 체크
            goNetworkCheck(param: param)
        
        case .permission:                       // 앱 접근 권한 실행
            goPermisson(param: param)
      
        case .appemgNotice:                   // 앱 기본정보 취득
            goAppEmergencyNotice()
        
        case .appUpdate:                      // 앱 업데이트 정보 취득
            goAppUpdateInfo(param: param)
        
        case .main:                             // 메인 실행
            goMain(param: param)
        }
    }
    
    func end() {
        
    }
    
    /**
     * 해당타스크 뒤로 이동
     * @param       sender : 현재 실행했던 타스크
     * @returns
     */
    func onBack(_ sender: TaskFlow) {
        
    }
    
    /**
     * 해당타스크 실패
     * @param       sender : 현재 실행했던 타스크
     * @returns
     */
    func onCancel(_ sender: TaskFlow) {
        switch sender {
        case .netCheck:     break
        case .permission:   break
        case .appemgNotice: break
        case .appUpdate:    break
        case .main: break
        default: break
        }
    }
    
    /**
     * 다음 타스크 진행
     * @param
     * @returns
     */
    func onNext(_ sender: TaskFlow, param: [String : Any]?) {
        queue = queue.filter({$0 != sender})
        runFlow(task: nextTask(), param:param)
    }
    
    /**
     * 네트워크 연결 체크
     * @param
     * @returns
     */
    func goNetworkCheck(param:[String:Any]?) {
        print("=====> NETWORK CHECK ")
        if !RealNetworkMonitor.shared.isConnected() {
            CommonPopupVC.present(context!, type: .one, configuration: {[weak self] vc in
                guard let self = self else { return }
                vc.oneTitle = "확인"
                vc.titleText = "네트워크 연결 오류"
                vc.detailText = "네트워크 연결이 되어있지않습니다.\n확인 후 다시 이용해 주세요"
                vc.oneBtnSelected = {[weak self] in
                    guard let self = self else { return }
                    self.onNext(.netCheck, param: nil)
                }
            })
        } else {
            onNext(.netCheck, param: nil)
        }
    }
    
    /**
     * 접근권한 동의 처리
     * @param
     * @returns
     */
    func goPermisson(param:[String:Any]?) {
        print("=====> PERMISSION ")
       
        PermissionVC.requiredPermissionCheck({
            print("permission check ok")
            self.onNext(.permission, param: nil)
        })
    }
    
    /**
     * 앱 시스템점검 확인 처리
     * @param
     * @returns
     */
    func goAppEmergencyNotice() {
        print("=====> EMERGENCYNOTICE")
        // 체크 로직 후 처리
        self.onNext(.appemgNotice, param: nil)
    }
    
    /**
     * 앱 업데이트 정보 처리
     * @param
     * @returns
     */
    func goAppUpdateInfo(param:[String:Any]?) {
        print("=====> APPUPDATEINFO")
        // 체크 로직 후 처리
        self.onNext(.appUpdate, param: nil)
    }

    
    /**
     * 메인 이동 처리
     * @param
     * @returns
     */
    func goMain(param:[String:Any]?) {
        print("================ MAIN ================")
        
        let vc = MainVC.instantiate()
        self.context?.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func testPopup() {
        CommonPopupVC.present(self.context!, type: .two, configuration: {[weak self] vc in
            guard let self = self else { return }
            vc.okTitle = "업데이트"
            vc.cancelTitle = "취소"
            vc.titleText = "앱업데이트가 있습니다."
            vc.detailText = "앱업데이트 테스트 입니다."
            vc.okBtnSelected = {[weak self] in
                guard let self = self else { return }
                self.onNext(.appUpdate, param: nil)
            }
        })
    }
}

