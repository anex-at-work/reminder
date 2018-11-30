import { State, Action, StateContext } from '@ngxs/store';
import { Reminder } from 'src/app/_shared/models/reminder';
import { SelectDay, SelectReminder, RefreshReminder } from './actions';

export interface DateModel {
  day: Date;
}

export interface ReminderModel {
  reminder: Reminder;
}

@State<DateModel>({
  name: 'day',
  defaults: { day: null }
})
export class DayState {
  @Action(SelectDay)
  setDate(ctx: StateContext<DateModel>, action: SelectDay) {
    const state = ctx.getState();
    ctx.setState({
      ...state,
      day: action.day
    });
  }
}

@State<ReminderModel>({
  name: 'reminder',
  defaults: { reminder: null }
})
export class EventState {
  @Action(SelectReminder)
  setDate(ctx: StateContext<ReminderModel>, action: SelectReminder) {
    const state = ctx.getState();
    ctx.setState({
      ...state,
      reminder: action.reminder
    });
  }
}
