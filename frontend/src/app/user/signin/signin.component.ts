import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AngularTokenService } from 'angular-token';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.scss']
})
export class SigninComponent implements OnInit {
  public hide: boolean = true;
  public formGroup = new FormGroup({
    password: new FormControl('', [Validators.required]),
    login: new FormControl('', [Validators.required, Validators.email])
  });
  constructor(
    private router: Router,
    private tokenService: AngularTokenService
  ) {}

  ngOnInit() {}

  public onSubmit(): void {
    this.tokenService.signIn(this.formGroup.value).subscribe(
      _ => {
        this.router.navigate(['/']);
      },
      error => {
        if (error['error'] && error['error']['errors']) {
          this.formGroup.get('login').setErrors({
            full_messages: error['error']['errors'].join(' ')
          });
        }
      }
    );
  }
}
