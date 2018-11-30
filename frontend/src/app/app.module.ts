import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';
import { HttpModule } from '@angular/http';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';

import { NgxsModule } from '@ngxs/store';
import { LoadingBarRouterModule } from '@ngx-loading-bar/router';
import { LoadingBarHttpClientModule } from '@ngx-loading-bar/http-client';
import { AngularTokenModule } from 'angular-token';

import { environment } from 'src/environments/environment';
import { DayState, EventState } from 'src/app/_shared/stores/state';
import { AppComponent } from 'src/app/app.component';
import { UserModule } from 'src/app/user/user.module';
import { SchedulerModule } from 'src/app/scheduler/scheduler.module';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpModule,
    HttpClientModule,
    RouterModule.forRoot([]),
    AngularTokenModule.forRoot({
      apiBase: environment.apiUrl
    }),
    NgxsModule.forRoot([DayState, EventState]),
    LoadingBarRouterModule,
    LoadingBarHttpClientModule,
    UserModule,
    SchedulerModule
  ],
  providers: [AngularTokenModule],
  bootstrap: [AppComponent]
})
export class AppModule {}
