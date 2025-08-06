@Preview
@Component
struct ExampleListItemPreview {
  build() {
    Column() {
      ExampleListItem({ title: 'title title title title' })
      Divider()
      ExampleListItem({ title: 'title title title title', subtitle: "subtitle subtitle subtitle subtitle" })
    }.width("100%")
  }
}

@Component
export default struct ExampleListItem {
  title?: string;
  subtitle?: string;

  build() {
    ListItem() {
      Button() {
        Column() {
          Text(this.title).width('100%').fontColor(Color.Black).fontSize(16)
          if (this.subtitle) {
            Text(this.subtitle).width('100%').fontColor(Color.Gray).fontSize(14)
          }
        }
      }
      .type(ButtonType.Normal)
      .width('100%')
      .padding({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5
      })
      .backgroundColor(Color.Transparent)
      .fontColor(Color.Blue)
      .align(Alignment.Start)
    }
  }
}