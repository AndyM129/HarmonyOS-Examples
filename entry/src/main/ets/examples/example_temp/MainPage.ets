import { router } from '@kit.ArkUI';

export class ItemModel {
  title: string | null = null;
}


@Observed
export class ViewModel {
  @Track pageTitle: string | null = 'MainPage';
  @Track items: ItemModel[] | null = [];
  @Track count: number = 0
}


@Preview
@Entry
@Component
export struct MainPage {
  @State viewModel: ViewModel = new ViewModel()
  private context?: Context = this.getUIContext().getHostContext();

  aboutToAppear() {
    console.info('[MainPage] aboutToAppear')
    this.viewModel.count = 1
  }

  onDidBuild(): void {
    console.info('[MainPage] onDidBuild')
  }

  aboutToDisappear() {
    console.info('[MainPage] aboutToDisappear')
  }

  build() {
    Column({ space: 20 }) {
      Text(this.viewModel.pageTitle).fontSize(24).fontWeight(FontWeight.Bold).textAlign(TextAlign.Center)
      Text(`当前计数：${this.viewModel.count}`).fontSize(18)
      Button('增加计数').onClick(() => {
        this.viewModel.count += 1
      })
      Button('back').onClick(() => {
        router.back()
      })
    }.width('100%').height('100%').padding(20)
  }
}

