import { inject, Injectable } from '@angular/core';
import {
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
  HTTP_INTERCEPTORS,
  HttpErrorResponse
} from '@angular/common/http';
import { Observable, catchError, throwError } from 'rxjs';
import { AuthService } from '../services/auth.service';
import { Router } from '@angular/router';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  private authService = inject(AuthService);
  private router = inject(Router);


  intercept(req: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    const token = this.authService.tokenValue?.accessToken ?? this.authService.tokenValue?.token;
    if (!token || req.url.endsWith('/token') || req.url.endsWith('/token/demo')) {
      return next.handle(req);
    }

    const authReq = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`
      }
    });
    return next.handle(authReq).pipe(
  catchError((error: unknown) => {
    // An expired or rejected token: clear it and send the user back to login once
    if (error instanceof HttpErrorResponse && error.status === 401) {
      this.authService.logout();
      this.router.navigate(['/login'], { queryParams: { reason: 'expired' } });
    }
    return throwError(() => error);
  })
);

  }
}

export const authInterceptorProvider = {
  provide: HTTP_INTERCEPTORS,
  useClass: AuthInterceptor,
  multi: true
};
