import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AngularTokenService, RegisterData } from 'angular-token';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {
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
    let information: RegisterData = this.formGroup.value;
    information['passwordConfirmation'] = information['password'];
    this.tokenService.registerAccount(information).subscribe(
      _ => {
        this.router.navigate(['/']);
      },
      error => {
        if (error['error'] && error['error']['errors']) {
          this.formGroup.get('login').setErrors(error['error']['errors']);
        }
      }
    );
  }
}
