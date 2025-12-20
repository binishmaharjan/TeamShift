import Foundation

public protocol ErrorTransformable {
    func toAppError() -> AppError
}
