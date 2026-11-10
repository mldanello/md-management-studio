import { test, expect } from '@playwright/test';

test('Contacts page loads for the demo user', async ({ page }) => {
  await page.goto('/login');
  await page.getByRole('button', { name: 'Demo' }).click();

  await expect(page.getByRole('heading', { name: 'Contacts', exact: true })).toBeVisible();
  await expect(page.getByLabel('Filter contacts')).toBeVisible();
});

test('a contact can be selected with the keyboard', async ({ page }) => {
  await page.goto('/login');
  await page.getByRole('button', { name: 'Demo' }).click();

  const list = page.getByRole('list', { name: 'Contact list' });
  const second = list.getByRole('listitem').nth(1);   // the first contact is auto-selected on load
  const name = second.getByRole('button').first();

  await name.focus();
  await page.keyboard.press('Enter');

  await expect(name).toHaveAttribute('aria-current', 'true');
  await expect(second.getByRole('button', { name: /^Edit / })).toBeVisible();
});
