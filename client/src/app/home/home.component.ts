import { Component, OnInit, inject, signal } from '@angular/core';
import { ApiService } from '../services/api.service';

@Component({
  standalone: true,
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  private api = inject(ApiService);
  readonly appVersion = signal('dev');

  checkingApi = signal(false);
  apiStatus = signal<'idle' | 'success' | 'error'>('idle');
  apiStatusMessage = signal('');

  async ngOnInit(): Promise<void> {
    const versionInfo = await this.api.getUiVersionInfo();
    const runtimeVersion = versionInfo?.appVersion?.trim();
    if (runtimeVersion) {
      this.appVersion.set(runtimeVersion);
    }
  }

  async checkApiConnection(): Promise<void> {
    this.checkingApi.set(true);
    this.apiStatus.set('idle');
    this.apiStatusMessage.set('Checking API connectivity...');

  try {
    const apiVersion = await this.api.getApiVersion();
    if (apiVersion) {
      this.apiStatus.set('success');
      this.apiStatusMessage.set(`API connection successful. API version ${this.shortVersion(apiVersion)}`);
    } else {
      this.apiStatus.set('error');
      this.apiStatusMessage.set('API connection failed.');
    }
  }
  catch {
      this.apiStatus.set('error');
      this.apiStatusMessage.set('API connection failed.');
    } finally {
      this.checkingApi.set(false);
    }
  }

  // "2.1.0+0c724048c8c0..." → "2.1.0+0c72404" (short git hash, like git log --oneline)
  private shortVersion(version: string): string {
    return version.replace(/\+([0-9a-f]{7})[0-9a-f]*$/, '+$1');
  }

}
