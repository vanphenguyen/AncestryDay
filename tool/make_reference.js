// Writes test/fixtures/icu_months.json: the first solar day of every lunar
// month from 1930 to 2100 according to ICU (the calendar data built into
// Node), for the Chinese ("chinese") and Korean ("dangi") calendars.
// Run: node tool/make_reference.js
const fs = require('fs');
const out = {};
for (const cal of ['chinese', 'dangi']) {
  const fmt = new Intl.DateTimeFormat('en-u-ca-' + cal, { timeZone: 'UTC', year: 'numeric', month: 'numeric', day: 'numeric' });
  const rows = [];
  for (let t = Date.UTC(1930, 0, 1); t <= Date.UTC(2100, 11, 31); t += 86400000) {
    const p = Object.fromEntries(fmt.formatToParts(new Date(t)).map(x => [x.type, x.value]));
    if (p.day !== '1') continue;
    const leap = /bis/.test(p.month);
    rows.push(new Date(t).toISOString().slice(0, 10) + ' ' + (leap ? 'L' : '') + parseInt(p.month));
  }
  out[cal] = rows;
}
fs.writeFileSync('test/fixtures/icu_months.json', JSON.stringify(out));
console.log(out.chinese.length, out.dangi.length, out.chinese.slice(0, 3), new Intl.DateTimeFormat('en-u-ca-chinese',{timeZone:'UTC'}).formatToParts(new Date(Date.UTC(2025,6,25))));
