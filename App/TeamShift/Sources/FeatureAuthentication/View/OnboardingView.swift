import SharedUIs
import SwiftUI

struct OnboardingView: View {
    init(coordinator: AuthenticationCoordinator, viewModel: OnboardingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    private weak var coordinator: AuthenticationCoordinator?
    @State private var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            PrimaryButton(
                image: .icnPersonAdd,
                title: l10.createAccount
            ) {
                print(l10.createAccount)
            }
            
            SecondaryButton(
                image: .icnLogin,
                title: l10.login
            ) {
                print(l10.login)
            }
            
            Text(continueAsGuestUserString)
                .font(.customCaption)
                .bold()
                .padding(10)
                .onTapGesture {
                    print("Continue as Guest User")
                }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(Color.background)
        .task {
            await viewModel.performSomeAction()
        }
    }
}

extension OnboardingView {
    private var continueAsGuestUserString: AttributedString {
        var attributedString = AttributedString(l10.continueAsGuestUser)
        if let range = attributedString.range(of: l10.continueAs) {
            attributedString[range].foregroundColor = Color.subText
        }
        if let range = attributedString.range(of: l10.guestUser) {
            attributedString[range].foregroundColor = Color.appPrimary
        }
        return attributedString
    }
}
