import Foundation
import SakatsuData

// MARK: UI state

struct SettingsUiState {
    var defaultSaunaTimes: DefaultSaunaTimes = .init()
    var settingsError: SettingsError?
}

// MARK: - Error

enum SettingsError: LocalizedError {
    case defaultSaunaSetFetchFailed(localizedDescription: String)
    case defaultSaunaSetSaveFailed(localizedDescription: String)

    var errorDescription: String? {
        switch self {
        case let .defaultSaunaSetFetchFailed(localizedDescription): localizedDescription
        case let .defaultSaunaSetSaveFailed(localizedDescription): localizedDescription
        }
    }
}

// MARK: - View model

@MainActor
final class SettingsViewModel<
    Repository: DefaultSaunaTimeRepository,
    Validator: SakatsuValidatorProtocol
>: ObservableObject {
    @Published private(set) var uiState: SettingsUiState

    private let repository: Repository
    private let validator: Validator

    init(
        repository: Repository = DefaultSaunaTimeUserDefaultsClient.shared,
        validator: Validator = SakatsuValidator()
    ) {
        self.uiState = SettingsUiState()
        self.repository = repository
        self.validator = validator
        refreshDefaultSaunaTimes()
    }
}

// MARK: - Event handler

extension SettingsViewModel {
    func onDefaultSaunaTimeChange(defaultSaunaTime: TimeInterval?) {
        guard validator.validate(saunaTime: defaultSaunaTime) else {
            return
        }
        uiState.defaultSaunaTimes.saunaTime = defaultSaunaTime
        saveDefaultSaunaSet()
    }

    func onDefaultCoolBathTimeChange(defaultCoolBathTime: TimeInterval?) {
        guard validator.validate(coolBathTime: defaultCoolBathTime) else {
            return
        }
        uiState.defaultSaunaTimes.coolBathTime = defaultCoolBathTime
        saveDefaultSaunaSet()
    }

    func onDefaultRelaxationTimeChange(defaultRelaxationTime: TimeInterval?) {
        guard validator.validate(relaxationTime: defaultRelaxationTime) else {
            return
        }
        uiState.defaultSaunaTimes.relaxationTime = defaultRelaxationTime
        saveDefaultSaunaSet()
    }

    func onErrorAlertDismiss() {
        uiState.settingsError = nil
    }
}

// MARK: - Privates

private extension SettingsViewModel {
    func refreshDefaultSaunaTimes() {
        do {
            uiState.defaultSaunaTimes = try repository.defaultSaunaTimes()
        } catch {
            uiState.settingsError = .defaultSaunaSetFetchFailed(localizedDescription: error.localizedDescription)
        }
    }

    func saveDefaultSaunaSet() {
        do {
            try repository.saveDefaultSaunaTimes(uiState.defaultSaunaTimes)
        } catch {
            uiState.settingsError = .defaultSaunaSetSaveFailed(localizedDescription: error.localizedDescription)
        }
    }
}
