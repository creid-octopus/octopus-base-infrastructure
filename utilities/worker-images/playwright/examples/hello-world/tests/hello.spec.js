const { test, expect } = require('@playwright/test');

// Renders a local page, so the test needs no network access.
test('hello world page shows its greeting', async ({ page }) => {
  await page.setContent('<h1>Hello, world</h1>');

  await expect(page.locator('h1')).toHaveText('Hello, world');
});
