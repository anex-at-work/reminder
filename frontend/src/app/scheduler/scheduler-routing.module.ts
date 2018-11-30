import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AngularTokenService } from 'angular-token';

import { DashboardComponent } from './dashboard/dashboard.component';

const routes: Routes = [
  {
    path: '',
    component: DashboardComponent,
    canActivate: [AngularTokenService]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SchedulerRoutingModule {}
