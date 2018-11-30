import { Component } from '@angular/core';
import { Router } from '@angular/router';

import { AngularTokenService } from 'angular-token';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent {
  constructor(
    private router: Router,
    private tokenService: AngularTokenService
  ) {
    this.tokenService.validateToken().subscribe(
      _ => {},
      _ => {
        this.router.navigate(['signin']);
      }
    );
  }
}
