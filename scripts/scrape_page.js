// Scrape the Arquivos section from penha.atende.net CONCIDADE page
// Requires: npm install playwright && npx playwright install chromium
//
// Usage: node scrape_page.js
//
// This script renders the JS-heavy page with headless Chromium and extracts
// the HTML of the "Arquivos Relacionados" section, which contains file hashes
// needed to build download URLs.

const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  await page.goto('https://penha.atende.net/cidadao/pagina/publicacoes-eivriv-concidade', {
    waitUntil: 'networkidle',
    timeout: 60000,
  });

  await page.waitForTimeout(8000);

  // Get the full HTML of the arquivos section directly
  const data = await page.evaluate(() => {
    const arquivosDiv = document.querySelector('.arquivos');
    if (!arquivosDiv) return { html: 'NOT FOUND', text: '' };
    return {
      html: arquivosDiv.innerHTML,
      text: arquivosDiv.innerText,
    };
  });

  console.log('=== ARQUIVOS TEXT ===');
  console.log(data.text);
  console.log('\n=== ARQUIVOS HTML ===');
  console.log(data.html);

  await browser.close();
})();
