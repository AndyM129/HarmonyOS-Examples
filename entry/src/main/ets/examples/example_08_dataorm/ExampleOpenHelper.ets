import { common } from '@kit.AbilityKit';
import { Database, OpenHelper } from '@ohos/dataorm';

export class ExampleOpenHelper extends OpenHelper {
  constructor(context: common.UIAbilityContext, name: string, customDir?: string) {
    super(context, name, customDir);
  }

  public async onCreateDatabase(db: Database): Promise<void> {
    super.onCreateDatabase(db);
  }

  async onUpgradeDatabase(db: Database, oldVersion: number, newVersion: number): Promise<void> {
    console.log("ExampleOpenHelper onUpgradeDatabase oldVersion:" + oldVersion + ",newVersion:" + newVersion);

    // db.execSQL('ALTER TABLE NOTE ADD COLUMN PLACE INTEGER');
    // db.execSQL('ALTER TABLE NOTE RENAME COLUMN MONEYS TO COST');
  }

  async onDowngradeDatabase(db: Database, oldVersion: number, newVersion: number): Promise<void> {
    console.log("ExampleOpenHelper onDowngradeDatabase oldVersion:" + oldVersion + ",newVersion:" + newVersion);

    // db.execSQL('ALTER TABLE NOTE DROP COLUMN TYPE');
    // db.execSQL('ALTER TABLE NOTE DROP COLUMN COST');
  }
}
