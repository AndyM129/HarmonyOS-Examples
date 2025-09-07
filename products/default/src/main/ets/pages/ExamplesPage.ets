import { HMRouter } from '@hadss/hmrouter';
import { ExamplesPageItemModel } from 'models/src/main/ets/models/ExamplesPageItemModel';
import { ExamplesPageViewModel } from '../view_models/ExamplesPageViewModel';
import { ExamplesPageListItem } from '../views/ExamplesPageListItem';


@HMRouter({ pageUrl: 'ExamplesPage' })
@ComponentV2
export struct ExamplesPage {
  viewModel: ExamplesPageViewModel = new ExamplesPageViewModel()

  aboutToAppear() {
    console.info('[ExamplesPage] aboutToAppear')
    this.viewModel.reloadItemModels()
  }

  onDidBuild(): void {
    console.info('[ExamplesPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[ExamplesPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[ExamplesPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[ExamplesPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[ExamplesPage] aboutToDisappear')
  }

  build() {
    Column() {
      this.pageTitleBarBuilder()
      this.pageBodyBuilder()
    }.width('100%').height('100%')
  }

  // 标题栏
  @Builder
  pageTitleBarBuilder() {
    Column() {
      RelativeContainer() {
        Text(this.viewModel.pageTitle)
          .id('title')
          .fontSize(18)
          .fontColor(0x222222)
          .fontWeight(FontWeight.Normal)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
          })
          .margin({ left: 50, right: 50 })
      }.height(43).width("100%")
    }.expandSafeArea([SafeAreaType.SYSTEM]).backgroundColor('#F2F3F5')
  }

  @Builder
  pageBodyBuilder() {
    List({ space: 10 }) {
      ForEach(this.viewModel.itemModels, (itemModel: ExamplesPageItemModel) => {
        ExamplesPageListItem({ itemModel: itemModel })
      }, (itemModel: ExamplesPageItemModel, index: number) => index.toString())
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }
}

