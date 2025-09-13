import { HMDefaultGlobalAnimator, HMNavigation } from '@hadss/hmrouter';
import { AttributeUpdater } from '@kit.ArkUI';

@Entry
@Component
struct IndexPage {
  modifier: NavModifier = new NavModifier();

  build() {

    // HMRouter：@Entry中需要再套一层容器组件,Column或者Stack
    Column() {

      // 使用HMNavigation容器
      HMNavigation({
        navigationId: 'MainNavigation', homePageUrl: 'ExamplesPage',
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifier
        }
      })
    }.height('100%').width('100%')
  }
}

class NavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.mode(NavigationMode.Stack);
    // instance.navBarWidth('100%');
    // instance.hideTitleBar(true);
    // instance.hideToolBar(true);
  }
}