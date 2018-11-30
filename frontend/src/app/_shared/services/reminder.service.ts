import { formatDate } from '@angular/common';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

import { Reminder } from 'src/app/_shared/models/reminder';

@Injectable({
  providedIn: 'root'
})
export class ReminderService {
  constructor(private http: HttpClient) {}

  public getIndex(date: Date): Observable<Reminder[]> {
    return this.http
      .get(
        `${environment.apiUrlVersioned}/reminders/${formatDate(
          date,
          'yyyy/MM',
          'en'
        )}`
      )
      .pipe(map(res => <Reminder[]>res));
  }

  public postCreate(reminder: Reminder): Observable<Reminder> {
    return this.http
      .post(`${environment.apiUrlVersioned}/reminders`, reminder)
      .pipe(
        map(res => {
          return <Reminder>res;
        })
      );
  }

  public putUpdate(reminder: Reminder): Observable<Reminder> {
    return this.http
      .put(`${environment.apiUrlVersioned}/reminders/${reminder.id}`, reminder)
      .pipe(
        map(res => {
          return <Reminder>res;
        })
      );
  }

  public deleteDestroy(reminder: Reminder): Observable<boolean> {
    return this.http
      .delete(`${environment.apiUrlVersioned}/reminders/${reminder.id}`)
      .pipe(
        map(res => {
          return <boolean>res;
        })
      );
  }
}
