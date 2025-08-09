import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';

type Nil = null | undefined;

class ItemModel {
  title?: string | Nil;

  constructor(title?: string | Nil) {
    this.title = title;
  }
}


@ObservedV2
class ViewModel {
  @Trace pageTitle: string | null = 'MainPage';
  @Trace items: ItemModel[] | null = [];
  @Trace count: number = 1
}


@Preview
@Entry
@ComponentV2
struct MainPage {
  viewModel: ViewModel = new ViewModel()
  context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  aboutToAppear() {
    console.info('[MainPage] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[MainPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[MainPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[MainPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[MainPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[MainPage] aboutToDisappear')
  }

  build() {
    Column({ space: 20 }) {
      Text(this.viewModel.pageTitle).fontSize(24).fontWeight(FontWeight.Bold).textAlign(TextAlign.Center)
      Text(`当前计数：${this.viewModel.items?.length}`).fontSize(18)
      Button('增加计数').onClick(() => {
        this.viewModel.items?.push(new ItemModel(`Item ${this.viewModel.items.length}`))
      })
      Button('back').onClick(() => {
        router.back()
      })
      List() {
        ForEach(this.viewModel.items, (item: ItemModel) => {
          MyListItem({ title: item.title })
        }, (item: string, index: number) => item)
      }.layoutWeight(1)
    }.width('100%').height('100%').padding(20)
  }
}

@Preview
@Component
struct MyListItem {
  @Prop title: string | Nil

  build() {
    ListItem() {
      Column() {
        Text(this.title).margin(10)
      }.width("100%").alignItems(HorizontalAlign.Start)
    }
  }
}