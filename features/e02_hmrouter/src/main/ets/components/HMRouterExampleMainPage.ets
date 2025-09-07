import { HMLifecycleState, HMPageParam, HMParamType, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { JSON } from '@kit.ArkTS';

// 详见文档：https://ohpm.openharmony.cn/#/cn/detail/@hadss%2Fhmrouter
@HMRouter({ pageUrl: 'HMRouterExampleMainPage', lifecycle: 'pageLifecycle', animator: 'pageAnimator' })
@Component
export struct HMRouterExampleMainPage {
  // 获取生命周期中定义的状态变量
  // @State model: ObservedModel | null = (HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle() as PageLifecycle).model
  @State pageParam: HMPageParam = HMRouterMgr.getCurrentParam(HMParamType.all) as HMPageParam

  aboutToAppear() {
    console.info('[HMRouterExampleMainPage] aboutToAppear')

    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onShown, this.onPageShown)
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onBackPressed, this.onBackPressed)
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onHidden, this.onPageHidden)
  }

  onDidBuild(): void {
    console.info('[HMRouterExampleMainPage] onDidBuild')
  }

  onPageShown(): void {
    console.info('[HMRouterExampleMainPage] onPageShown')
  }

  onBackPressed(): void {
    console.info('[HMRouterExampleMainPage] onBackPressed')
  }

  onPageHidden(): void {
    console.info('[HMRouterExampleMainPage] onPageHidden')
  }

  aboutToDisappear() {
    console.info('[HMRouterExampleMainPage] aboutToDisappear')
  }

  build() {
    Column() {
      Text('Hello\nHMRouter')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      // Text(`${this.model?.property}`)

      Text(`pageParam = ${JSON.stringify(this.pageParam, null, 4)}`).width('100%').lineHeight(30)
    }.layoutWeight(1).justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Start)
  }
}
