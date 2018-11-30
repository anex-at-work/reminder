import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatDialogModule } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CalendarModule, DateAdapter } from 'angular-calendar';
import { adapterFactory } from 'angular-calendar/date-adapters/date-fns';
import { NgxMaterialTimepickerModule } from 'ngx-material-timepicker';

import { SchedulerRoutingModule } from './scheduler-routing.module';
import { DashboardComponent } from './dashboard/dashboard.component';
import { DashboardMonthComponent } from './dashboard/dashboard-month/dashboard-month.component';
import { DashboardFormComponent } from './dashboard/dashboard-form/dashboard-form.component';

@NgModule({
  declarations: [
    DashboardComponent,
    DashboardMonthComponent,
    DashboardFormComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatDialogModule,
    MatIconModule,
    MatToolbarModule,
    SchedulerRoutingModule,
    BrowserAnimationsModule,
    NgxMaterialTimepickerModule.forRoot(),
    CalendarModule.forRoot({
      provide: DateAdapter,
      useFactory: adapterFactory
    })
  ]
})
export class SchedulerModule {}
