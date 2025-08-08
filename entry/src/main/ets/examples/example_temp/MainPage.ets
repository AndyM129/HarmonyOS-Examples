import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';

export class ItemModel {
  title: string | null = null;
}


@Observed
export class ViewModel {
  @Track pageTitle: string | null = 'MainPage';
  @Track items: ItemModel[] | null = [];
  @Track count: number = 1
}


@Preview
@Entry
@Component
export struct MainPage {
  @State viewModel: ViewModel = new ViewModel()
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

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
    Scroll() {
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
}

