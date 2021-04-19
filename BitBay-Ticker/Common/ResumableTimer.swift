import Foundation

final class ResumableTimer {
    
    private let fireDate: Date
    private let completion: (() -> ())?
    
    private var timer: Timer?
    
    init(fireDate: Date, completion: (() -> (Void))?) {
        self.fireDate = fireDate
        self.completion = completion
        
        setUpTimer()
    }
    
    func resume(nowDate: Date = Date()) {
        guard nowDate < fireDate else {
            pause()
            completion?()
            
            return
        }
        
        setUpTimer()
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setUpTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: fireDate.timeIntervalSinceNow, repeats: false) { [weak self] _ in
            self?.completion?()
        }
    }
    
}
