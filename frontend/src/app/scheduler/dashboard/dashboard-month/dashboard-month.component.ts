import { Component, OnInit, ChangeDetectionStrategy } from '@angular/core';
import { Store, Actions, ofActionDispatched } from '@ngxs/store';
import { Subject } from 'rxjs';
import { CalendarEvent, CalendarView } from 'angular-calendar';
import { isSameDay, isSameMonth, isBefore } from 'date-fns';
import * as moment from 'moment';
import * as lodash from 'lodash';

import {
  SelectDay,
  SelectReminder,
  RefreshReminder
} from 'src/app/_shared/stores/actions';
import { Reminder } from 'src/app/_shared/models/reminder';
import { ReminderService } from 'src/app/_shared/services/reminder.service';

@Component({
  selector: 'app-dashboard-month',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './dashboard-month.component.html',
  styleUrls: ['./dashboard-month.component.scss']
})
export class DashboardMonthComponent implements OnInit {
  public viewDate: Date = new Date();
  public view: CalendarView = CalendarView.Month;
  public events: CalendarEvent[];
  public activeDayIsOpen: boolean = false;
  public refresh: Subject<any> = new Subject();

  constructor(
    private store: Store,
    private reminderService: ReminderService,
    private actions$: Actions
  ) {}

  ngOnInit() {
    this.actions$.pipe(ofActionDispatched(RefreshReminder)).subscribe(_ => {
      this.getMonthEvents();
    });
    this.getMonthEvents();
  }

  public dayClicked({
    date,
    events
  }: {
    date: Date;
    events: CalendarEvent[];
  }): void {
    if (isSameMonth(date, this.viewDate)) {
      this.viewDate = date;
      if (
        (isSameDay(this.viewDate, date) && this.activeDayIsOpen === true) ||
        events.length === 0
      ) {
        this.activeDayIsOpen = false;
      } else {
        this.activeDayIsOpen = true;
      }
    }
    this.store.dispatch(
      new SelectDay(isBefore(this.viewDate, new Date()) ? null : this.viewDate)
    );
  }

  public handleEvent(event: CalendarEvent): void {
    this.store.dispatch(new SelectReminder(<Reminder>event.meta));
  }

  public onViewDateChange(): void {
    this.store.dispatch(
      new SelectDay(isBefore(this.viewDate, new Date()) ? null : this.viewDate)
    );
    this.getMonthEvents();
  }

  private getMonthEvents(): void {
    this.reminderService.getIndex(this.viewDate).subscribe(res => {
      if (!res) return;
      this.events = lodash.flatten(<CalendarEvent[][]>res.map(
        (event: Reminder) => {
          return event.calculated_date.map((calculated: string) => {
            event;
            return {
              start: moment(calculated, [
                moment.HTML5_FMT.DATETIME_LOCAL_MS,
                moment.HTML5_FMT.DATE
              ]).toDate(),
              title: `${event.time_at} ${event.title}`,
              meta: event
            };
          });
        }
      ));
      this.refresh.next();
    });
  }
}
