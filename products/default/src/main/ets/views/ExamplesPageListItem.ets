import { ExamplesPageItemModel } from 'models/src/main/ets/models/ExamplesPageItemModel'

@Preview
@ComponentV2
export struct ExamplesPageListItem {
  @Param itemModel: ExamplesPageItemModel | null = null

  build() {
    ListItem() {
      Column() {
        Row() {
          Text(this.itemModel?.title).fontSize(16).layoutWeight(1)
          Text('>>').fontSize(16)
        }

        Blank().height(10)
        Text(this.itemModel?.subtitle)
          .width('100%')
          .fontSize(14)
          .fontColor(Color.Gray)
          .fontStyle(FontStyle.Normal)
          .fontWeight(FontWeight.Normal)
          .maxLines(10)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }.width("100%").padding({ top: 10, bottom: 10 }).alignItems(HorizontalAlign.Start)
    }.onClick(this.itemModel?.onClick)
  }
}