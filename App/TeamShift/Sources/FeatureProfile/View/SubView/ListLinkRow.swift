import SharedUIs
import SwiftUI

// MARK: Normal List Item
struct ListLinkRow: View {
    var profileRow: ProfileRow
    var onRowTapped: ((ProfileRow) -> Void)?
    
    var body: some View {
        Button {
            onRowTapped?(profileRow)
        } label: {
            HStack {
                profileRow.image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.appPrimary)
                
                Text(profileRow.title)
                
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
