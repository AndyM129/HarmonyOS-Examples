import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { relationalStore } from '@kit.ArkData';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
// import { DaoMaster, DaoTraceSpace, Database, GlobalContext } from '@ohos/dataorm';
// import { ExampleOpenHelper } from '../examples/example_08_dataorm/ExampleOpenHelper';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');

    await this.setupDataorm()
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void { // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/IndexPage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void { // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void { // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void { // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  // @ohos/dataorm 初始化
  async setupDataorm() {
    // let dbName = 'harmony_os_examples.db'
    // let helper: ExampleOpenHelper = new ExampleOpenHelper(this.context, dbName);
    // helper.setEncrypt(false); // 设定数据加密密钥，加密后不可变更，加密和非加密库暂不能切换
    // helper.setLogger(true)
    // helper.setTrace({
    //   enabled: true, minLevel: DaoTraceSpace.TraceLevel.INFO, types: new Set([DaoTraceSpace.TraceType.CRUD])
    // })
    // helper.setSecurityLevel(relationalStore.SecurityLevel.S1); // 设置数据库安全等级，不设置则默认为S1
    // await helper.setVersion(100901) // 设置新的数据库版本,如果新版本中包含表更新实例将在这调用onUpgradeDatabase进行表更新
    // await helper.setAutoMigrate(true)
    //
    // let db: Database = await helper.getWritableDb();
    // db.name = dbName
    // GlobalContext.getContext().setValue("daoSession", new DaoMaster(db).newSession());
    //
    // hilog.info(DOMAIN, 'testTag', '%{public}s', 'setup dataorm');
  }
}