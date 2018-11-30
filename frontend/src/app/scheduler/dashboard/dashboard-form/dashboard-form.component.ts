import { Component, OnInit } from '@angular/core';
import { Store } from '@ngxs/store';
import { FormGroup, FormControl, Validators } from '@angular/forms';

import { RefreshReminder } from 'src/app/_shared/stores/actions';
import { Reminder } from 'src/app/_shared/models/reminder';
import { ReminderService } from 'src/app/_shared/services/reminder.service';

export interface SelectValue {
  value: string;
  viewValue: string;
}

@Component({
  selector: 'app-dashboard-form',
  templateUrl: './dashboard-form.component.html',
  styleUrls: ['./dashboard-form.component.scss']
})
export class DashboardFormComponent implements OnInit {
  public reminder: Reminder = new Reminder();
  public formGroup: FormGroup = new FormGroup({
    title: new FormControl('', [Validators.required]),
    description: new FormControl('', []),
    date_at: new FormControl(new Date(), []),
    time_at: new FormControl('12:00', [Validators.required]),
    user_date: new FormControl('', []),
    repeat_type: new FormControl('never', [])
  });
  public repeatTypes: SelectValue[] = [
    { value: 'never', viewValue: 'Never' },
    { value: 'weekly', viewValue: 'Weekly' },
    { value: 'monthly', viewValue: 'Monthly' }
  ];

  constructor(private store: Store, private reminderService: ReminderService) {}

  ngOnInit() {
    this.store
      .select(state => state.day)
      .subscribe((res: { event: any; day: Date | null }) => {
        if (!res.day) return;
        this.resetWithDefault();
        this.formGroup.get('date_at').setValue(res.day);
        this.formGroup.setValidators(!res.day ? [Validators.required] : []);
        this.reminder = new Reminder();
      });
    this.store
      .select(state => state.reminder)
      .subscribe((res: { event: any; reminder: Reminder | null }) => {
        if (!res.reminder) return;
        this.reminder = res.reminder;
        Object.keys(this.formGroup.controls).forEach(k => {
          this.formGroup.get(k).setValue(this.reminder[k]);
        });
      });
  }

  public onSave(): boolean {
    if (this.reminder.id) {
      Object.keys(this.formGroup.controls).forEach(k => {
        this.reminder[k] = this.formGroup.get(k).value;
      });
      this.reminderService.putUpdate(this.reminder).subscribe(
        _ => {
          this.store.dispatch(new RefreshReminder());
        },
        _ => {}
      );
    } else {
      this.reminder = this.formGroup.value;
      this.reminderService.postCreate(this.reminder).subscribe(
        _ => {
          this.store.dispatch(new RefreshReminder());
          this.resetWithDefault();
        },
        _ => {}
      );
    }
    return false;
  }

  public onDelete(): boolean {
    this.reminderService.deleteDestroy(this.reminder).subscribe(
      _ => {
        this.store.dispatch(new RefreshReminder());
        this.resetWithDefault();
      },
      _ => {}
    );
    return false;
  }

  private resetWithDefault(): void {
    this.formGroup.reset({ repeat_type: 'never', time_at: '12:00' });
  }
}
