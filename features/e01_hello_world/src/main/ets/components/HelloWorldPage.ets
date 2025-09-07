import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ExamplesPageItemModel } from 'models';

@HMRouter({ pageUrl: 'HelloWorldPage' })
@Component
export struct HelloWorldPage {
  @State count: number = 0;

  // 静态方法，用于在示例页面中展示
  static examplesPageItemModel() {
    return new ExamplesPageItemModel({
      title: 'HelloWorldPage', subtitle: 'This is an HelloWorld example', onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'HelloWorldPage', param: {}
        });
      }
    });
  }

  build() {
    RelativeContainer() {
      Column() {
        Text('Hello HarmonyOS').fontSize(30).fontWeight(FontWeight.Bold)
        Text(`You have pushed the button ${this.count} times.`).margin({ top: 10 })
      }.alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      }).margin({ bottom: 100 })

      Button('+1')
        .width(50)
        .height(50)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          right: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })
        .margin({ right: 30, bottom: 100 })
        .onClick(() => {
          this.count++;
        })

    }.height('100%').width('100%')
  }
}