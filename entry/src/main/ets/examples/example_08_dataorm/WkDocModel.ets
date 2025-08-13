import { Columns, ColumnType, Entity, Id, Index, NotNull } from '@ohos/dataorm';

@Entity('WkDocModel')
export class WkDocModel {
  @Columns({ columnName: 'pkId', types: ColumnType.num }) @Id({ autoincrement: true }) pkId?: number | null; // 主键id
  @Columns({ columnName: 'docId', types: ColumnType.str }) @NotNull() @Index(true) docId?: string | null;
  @Columns({ columnName: 'title', types: ColumnType.str }) title?: string | null;
  @Columns({ columnName: 'lastViewedTimestamp', types: ColumnType.num }) lastViewedTimestamp?: number | null;

  constructor(pkId?: number, docId?: string, title?: string, lastViewedTimestamp?: number) {
    this.pkId = pkId;
    this.docId = docId;
    this.title = title;
    this.lastViewedTimestamp = lastViewedTimestamp;
  }

  get lastViewedDate() {
    return this.lastViewedTimestamp ? new Date(this.lastViewedTimestamp) : null;
  }

  set lastViewedDate(value: Date | null) {
    this.lastViewedTimestamp = value ? value.getTime() : null;
  }
}