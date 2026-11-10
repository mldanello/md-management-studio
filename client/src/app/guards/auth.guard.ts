import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = () => {
  const authService = inject(AuthService);
  const router = inject(Router);
  const isAuthenticated = authService.isAuthenticated();
  const debugEnabled = localStorage.getItem('md-auth-debug') === 'true';

  if (debugEnabled) {
    console.log('[AuthGuard] canActivate', {
      isAuthenticated,
      hasAccessToken: !!authService.tokenValue?.accessToken
    });
  }

  if (isAuthenticated) {
    return true;
  }

  if (debugEnabled) {
    console.log('[AuthGuard] redirecting to /login');
  }
  // A token that exists but failed the check has expired: clear it and say why
  const hadToken = !!authService.tokenValue?.accessToken;
  if (hadToken) {
    authService.logout();
  }
  return router.createUrlTree(['/login'], hadToken ? { queryParams: { reason: 'expired' } } : {});
};
