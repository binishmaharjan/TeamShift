import SwiftUI
import SharedUIs

// MARK: Normal List Item
struct NavigationLinkRow: View {
    var title: String
    var image: Image
    
    var body: some View {
        Button {
        } label: {
            HStack {
                image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.appPrimary)
                
                Text(title)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .renderingMode(.template)
                    .foregroundStyle(Color.appPrimary)
            }
            .padding(.vertical, 12)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .contentShape(Rectangle())
            .font(.customSubHeadline)
            .foregroundStyle(Color.text)
        }
    }
}
