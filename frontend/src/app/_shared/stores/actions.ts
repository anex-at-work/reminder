import { Reminder } from 'src/app/_shared/models/reminder';

export class SelectDay {
  static readonly type = '[Day] Select';
  constructor(public day: Date) {}
}

export class SelectReminder {
  static readonly type = '[Reminder] Select';
  constructor(public reminder: Reminder) {}
}

export class RefreshReminder {
  static readonly type = '[Reminder] Refresh';
  constructor() {}
}
