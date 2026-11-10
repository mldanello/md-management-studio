import { test, expect } from '@playwright/test';

test('API health check reports the API version', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Check API Connection' }).click();

  await expect(page.getByText(/API connection successful\. API version \d+\.\d+\.\d+/)).toBeVisible();
});