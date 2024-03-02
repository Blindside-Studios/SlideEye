import SwiftUI

struct QuoteSortButton: View {
    @Binding var sortByYear: Bool
    
    var body: some View {
        Menu {
            Button(action: {
                sortByYear = false
            }) {
                HStack {
                    Text("Date Added")
                    if !sortByYear {
                        Image(systemName: "checkmark")
                    }
                }
            }
            Button(action: {
                sortByYear = true
            }) {
                HStack {
                    Text("Year")
                    if sortByYear {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
        }
    }
}

#Preview {
    QuoteSortButton(sortByYear: .constant(false))
}
