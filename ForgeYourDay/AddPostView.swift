import SwiftUI

struct AddPostView: View {
    var body: some View {
        NavigationView {
            Text("Add a new post here.")
                .navigationTitle("Add Post")
        }
    }
}

#Preview {
    AddPostView()
} 