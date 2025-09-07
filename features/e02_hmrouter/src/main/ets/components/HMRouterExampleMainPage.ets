import { HMPageParam, HMParamType, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { JSON } from '@kit.ArkTS';

// 详见文档：https://ohpm.openharmony.cn/#/cn/detail/@hadss%2Fhmrouter
@HMRouter({ pageUrl: 'HMRouterExampleMainPage', lifecycle: 'pageLifecycle', animator: 'pageAnimator' })
@Component
export struct HMRouterExampleMainPage {
  // 获取生命周期中定义的状态变量
  // @State model: ObservedModel | null = (HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle() as PageLifecycle).model
  @State pageParam: HMPageParam = HMRouterMgr.getCurrentParam(HMParamType.all) as HMPageParam

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
