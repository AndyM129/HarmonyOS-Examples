@Component
export default struct NavigationBar {
  @State title: string | null = null;

  build() {
    Row() {
      Text(this.title).fontSize(20).margin({ left: 12 })
    }.height(56).padding({ left: 16 }).backgroundColor('#F5F5F5')
  }
}