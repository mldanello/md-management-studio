import { test, expect } from "@playwright/test";

test.describe("Authentication", () => {
  test("Demo button signs in and opens Contacts", async ({ page }) => {
    await page.goto("/login");
    await page.getByRole("button", { name: "Demo" }).click();

    await expect(page).toHaveURL(/\/contacts$/);
    await expect(page.getByRole("button", { name: "Logout" })).toBeVisible();
  });

  test("a logged-out visitor is sent to the login page", async ({ page }) => {
    await page.goto("/contacts");

    await expect(page).toHaveURL(/\/login/);
    await expect(page.getByRole("heading", { name: "Sign in" })).toBeVisible();
  });
  
  test('an expired session shows the session-expired message', async ({ page }) => {
    // Runs before the app's own scripts: plant a token whose expiry is in the past
    await page.addInitScript(() => {
      sessionStorage.setItem('md-management-token', JSON.stringify({
        accessToken: 'expired-token',
        expiresIn: 3600,
        expires_at: '2020-01-01T00:00:00.000Z'
      }));
    });

    await page.goto('/contacts');

    await expect(page).toHaveURL(/\/login\?reason=expired/);
    await expect(page.getByText('Your session expired. Please sign in again.')).toBeVisible();
  });

});
