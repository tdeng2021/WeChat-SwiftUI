import Combine
import SwiftUI

final class MyProfileFieldUpdateViewModel: ObservableObject {

  @Published
  var userSelfUpdateStatus: ValueUpdateStatus<User> = .idle
  private var userSelfUpdateCancellable: AnyCancellable?

  func updateUserSelf(_ newUser: User) {
    userSelfUpdateStatus = .updating
    userSelfUpdateCancellable?.cancel()

    userSelfUpdateCancellable = AppEnvironment.current.firestoreService
      .overrideUser(newUser)
      .sinkForUI(receiveCompletion: { [weak self] completion in

        switch completion {
        case .finished:
          self?.userSelfUpdateStatus = .finished(newUser)
        case let .failure(error):
          self?.userSelfUpdateStatus = .failed(error)
        }
      })
  }
}

// MARK: - Getters
extension MyProfileFieldUpdateViewModel {
  var isUserSelfUpdated: Bool {
    userSelfUpdateStatus.value != nil
  }
}
