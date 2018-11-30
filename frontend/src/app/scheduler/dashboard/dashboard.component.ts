import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { AngularTokenService } from 'angular-token';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  constructor(
    public router: Router,
    private tokenService: AngularTokenService
  ) {}

  ngOnInit() {}

  public onSignOut(): boolean {
    this.tokenService.signOut().subscribe();
    this.router.navigateByUrl('/signin');
    return false;
  }
}
