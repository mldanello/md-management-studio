import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom, retry, timeout, timer } from 'rxjs';
import { AuthToken } from '../models/auth-token.model';
import { ContactList } from '../models/contact-list.model';
import { ContactDetail, ContactSearchTag } from '../models/contact-detail.model';

import { environment } from '../../environments/environment';
import { ClientConfig } from '../models/client-config.model';

export interface UiVersionInfo {
  appName: string;
  appVersion: string;
  buildTimestampUtc: string;
  gitCommit: string | null;
  serverStartedAtUtc: string;
  parseError?: string;
}

@Injectable({ providedIn: 'root' })
export class ApiService {
  private readonly baseUrl = environment.apiBaseUrl;
  private readonly searchTagsCacheTtlMs = 2 * 60 * 1000;
  private searchTagsCache: { value: string[]; expiresAt: number } | null = null;

  constructor(private http: HttpClient) {}

  get tokenUrl(): string {
    return `${this.baseUrl}/token`;
  }

  get contactsUrl(): string {
    return `${this.baseUrl}/contacts`;
  }

  get searchTagsUrl(): string {
    return `${this.baseUrl}/searchtags`;
  }

  async authenticate(username: string, password: string): Promise<AuthToken> {
    return firstValueFrom(this.http.post<AuthToken>(this.tokenUrl, { username, password }));
  }

  async authenticateDemo(): Promise<AuthToken> {
    return firstValueFrom(this.http.post<AuthToken>(`${this.tokenUrl}/demo`, {}));
  }

  async getClientConfig(): Promise<ClientConfig> {
    return firstValueFrom(this.http.get<ClientConfig>(`${this.baseUrl}/config`));
  }

  async getUiVersionInfo(): Promise<UiVersionInfo | null> {
    try {
      return await firstValueFrom(
        this.http
          .get<UiVersionInfo>('/__version')
          .pipe(timeout(1500), retry({ count: 1, delay: () => timer(250) }))
      );
    } catch {
      return null;
    }
  }

  async listContacts(): Promise<ContactList[]> {
    const payload = await firstValueFrom(this.http.get<unknown>(this.contactsUrl));
    return this.toContactList(payload);
  }

  async getContact(id: number): Promise<ContactDetail> {
    return firstValueFrom(this.http.get<ContactDetail>(`${this.contactsUrl}/${id}`));
  }

  async addContact(contact: ContactDetail): Promise<ContactDetail> {
    const saved = await firstValueFrom(this.http.post<ContactDetail | null>(this.contactsUrl, contact));
    const resolvedContact = saved ?? contact;
    this.mergeSearchTagsIntoCache(resolvedContact.contactSearchTags ?? contact.contactSearchTags ?? []);
    return resolvedContact;
  }

  async updateContact(contact: ContactDetail): Promise<ContactDetail> {
    const saved = await firstValueFrom(this.http.put<ContactDetail | null>(`${this.contactsUrl}/${contact.id}`, contact));
    const resolvedContact = saved ?? contact;
    this.mergeSearchTagsIntoCache(resolvedContact.contactSearchTags ?? contact.contactSearchTags ?? []);
    return resolvedContact;
  }

  async deleteContact(id: number): Promise<void> {
    await firstValueFrom(this.http.delete<void>(`${this.contactsUrl}/${id}`));
  }

  async listSearchTags(): Promise<string[]> {
    const cached = this.getValidSearchTagsCache();
    if (cached) {
      return [...cached];
    }

    const tags = await firstValueFrom(this.http.get<string[]>(this.searchTagsUrl));
    this.setSearchTagsCache(tags);
    return [...tags];
  }

  private getValidSearchTagsCache(): string[] | null {
    if (!this.searchTagsCache) {
      return null;
    }

    if (Date.now() >= this.searchTagsCache.expiresAt) {
      this.searchTagsCache = null;
      return null;
    }

    return this.searchTagsCache.value;
  }

  private setSearchTagsCache(tags: string[]): void {
    this.searchTagsCache = {
      value: [...tags],
      expiresAt: Date.now() + this.searchTagsCacheTtlMs
    };
  }

  private mergeSearchTagsIntoCache(tags: ContactSearchTag[]): void {
    const normalizedIncoming = this.toDistinctSortedTags(
      tags
        .filter(tag => tag.isActive)
        .map(tag => (tag.tagText ?? '').trim())
        .filter(tagText => tagText.length > 0)
    );

    if (normalizedIncoming.length === 0) {
      return;
    }

    const existing = this.getValidSearchTagsCache() ?? [];
    const merged = this.toDistinctSortedTags([...existing, ...normalizedIncoming]);
    this.setSearchTagsCache(merged);
  }

  private toDistinctSortedTags(tagTexts: string[]): string[] {
    const unique = Array.from(new Set(tagTexts.map(tagText => tagText.toLowerCase())));
    const byKey = new Map(tagTexts.map(tagText => [tagText.toLowerCase(), tagText]));
    return unique
      .map(key => byKey.get(key) ?? key)
      .sort((a, b) => a.localeCompare(b, undefined, { sensitivity: 'base' }));
  }

  private unwrapCollectionPayload(payload: unknown): unknown {
    if (Array.isArray(payload)) {
      return payload;
    }

    if (!payload || typeof payload !== 'object') {
      return payload;
    }

    const maybeWrapped = payload as {
      items?: unknown;
      value?: unknown;
      results?: unknown;
      data?: unknown;
      $values?: unknown;
    };

    return (
      maybeWrapped.items ??
      maybeWrapped.value ??
      maybeWrapped.results ??
      maybeWrapped.data ??
      maybeWrapped.$values ??
      payload
    );
  }

  private toContactList(payload: unknown): ContactList[] {
    const root = this.unwrapCollectionPayload(payload);
    if (!Array.isArray(root)) {
      return [];
    }

    return root
      .filter((item): item is Record<string, unknown> => !!item && typeof item === 'object')
      .map(item => {
        const id = Number(item['id'] ?? 0);
        const firstName = String(item['firstName'] ?? '');
        const lastName = String(item['lastName'] ?? '');
        const rawSearchTags = item['searchTags'];

        return {
          id,
          firstName,
          lastName,
          searchTags: this.toStringList(rawSearchTags)
        };
      });
  }

  private toStringList(value: unknown): string[] {
    if (Array.isArray(value)) {
      return value
        .filter((item): item is string => typeof item === 'string')
        .map(item => item.trim())
        .filter(item => item.length > 0);
    }

    if (typeof value === 'string') {
      return value
        .split(',')
        .map(item => item.trim())
        .filter(item => item.length > 0);
    }

    return [];
  }

  async getApiVersion(): Promise<string | null> {
    try {
      const info = await firstValueFrom(
        this.http.get<{ appVersion: string }>(`${this.baseUrl}/version`).pipe(timeout(5000))
      );
      return info?.appVersion ?? null;
    } catch {
      return null;
    }
  }
}