import { Injectable, computed, signal } from '@angular/core';
import { ApiService } from './api.service';
import { AuthToken } from '../models/auth-token.model';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly tokenKey = 'md-management-token';
  private readonly authDebugKey = 'md-auth-debug';
  private tokenSignal = signal<AuthToken | null>(this.loadToken());
  readonly token = this.tokenSignal.asReadonly();
  readonly isAuthenticatedSignal = computed(() => !!this.tokenSignal()?.accessToken);

  constructor(private api: ApiService) { }

  get tokenValue(): AuthToken | null {
    return this.tokenSignal();
  }

  isAuthenticated(): boolean {
    const token = this.tokenValue;
    if (!token?.accessToken) {
      return false;
    }
    return !token.expires_at || Date.parse(token.expires_at) > Date.now();
  }


  async login(username: string, password: string): Promise<AuthToken> {
    this.debugLog('login:start', { username });
    return this.completeLogin(await this.api.authenticate(username, password));
  }

  async loginDemo(): Promise<AuthToken> {
    this.debugLog('loginDemo:Start');
    return this.completeLogin(await this.api.authenticateDemo());
  }

  private completeLogin(token: AuthToken): AuthToken {
    const normalizedToken = this.normalizeToken(token);
    this.saveToken(normalizedToken);
    this.tokenSignal.set(normalizedToken);
    this.debugLog('login:success', {
      hasAccessToken: !!normalizedToken.accessToken,
      expiresIn: normalizedToken.expiresIn,
      expiresAt: normalizedToken.expires_at
    });
    return normalizedToken;
  }

  logout(): void {
    sessionStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.tokenKey);
    this.tokenSignal.set(null);
    this.debugLog('logout');
  }

  private loadToken(): AuthToken | null {
    const raw = sessionStorage.getItem(this.tokenKey) ?? localStorage.getItem(this.tokenKey);
    if (!raw) {
      return null;
    }

    try {
      const token = this.normalizeToken(JSON.parse(raw) as AuthToken);
      // Keep authentication scoped to the current browser session.
      sessionStorage.setItem(this.tokenKey, JSON.stringify(token));
      localStorage.removeItem(this.tokenKey);
      this.debugLog('loadToken:success', { hasAccessToken: !!token.accessToken });
      return token;
    } catch {
      this.debugLog('loadToken:invalid-json');
      return null;
    }
  }

  private saveToken(token: AuthToken): void {
    sessionStorage.setItem(this.tokenKey, JSON.stringify(token));
    localStorage.removeItem(this.tokenKey);
  }

  private normalizeToken(token: AuthToken): AuthToken {
    const tokenData = token as AuthToken & {
      token_type?: string;
      expires_in?: number;
    };

    const normalized = {
      accessToken: tokenData.accessToken ?? tokenData.access_token ?? tokenData.token,
      token: tokenData.token,
      expiresIn: tokenData.expiresIn ?? tokenData.expires_in,
      expires_at: tokenData.expires_at ?? this.computeExpiresAt(tokenData.expiresIn ?? tokenData.expires_in)
    };

    this.debugLog('normalizeToken', {
      inputKeys: Object.keys(tokenData),
      hasAccessToken: !!normalized.accessToken
    });

    return normalized;
  }

  // expires_in is seconds from now; store an absolute time so the check still works after a page refresh
  private computeExpiresAt(expiresInSeconds?: number): string | undefined {
    return expiresInSeconds ? new Date(Date.now() + expiresInSeconds * 1000).toISOString() : undefined;
  }

  private isDebugEnabled(): boolean {
    return localStorage.getItem(this.authDebugKey) === 'true';
  }

  private debugLog(event: string, data?: Record<string, unknown>): void {
    if (!this.isDebugEnabled()) {
      return;
    }
    console.log(`[AuthService] ${event}`, data ?? '');
  }
}
