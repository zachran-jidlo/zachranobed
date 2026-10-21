const { test } = require("node:test");
const assert = require("node:assert/strict");
const { DateTime } = require("luxon");
const {
  getNextWeekday,
  getNextWorkingDay,
  toPragueDateKey,
} = require("../lib/utils/dateUtils");

/** Creates a Date from a local Prague date-time string. */
function prague(isoLocal) {
  return DateTime.fromISO(isoLocal, { zone: "Europe/Prague" }).toJSDate();
}

const holidays = new Set([
  "2026-10-28",
  "2026-12-24",
  "2026-12-25",
  "2026-12-26",
  "2027-03-26",
  "2027-03-29",
]);

test("donation target is skipped on a mid-week holiday", () => {
  const target = getNextWeekday(prague("2026-10-27T16:00"));
  assert.equal(toPragueDateKey(target), "2026-10-28");
  assert.ok(holidays.has(toPragueDateKey(target)));

  const nextTarget = getNextWeekday(prague("2026-10-28T16:00"));
  assert.equal(toPragueDateKey(nextTarget), "2026-10-29");
  assert.ok(!holidays.has(toPragueDateKey(nextTarget)));
});

test("Easter skips Friday and Monday, Monday run creates Tuesday", () => {
  const thursdayTarget = getNextWeekday(prague("2027-03-25T16:00"));
  assert.equal(toPragueDateKey(thursdayTarget), "2027-03-26");
  assert.ok(holidays.has(toPragueDateKey(thursdayTarget)));

  const fridayTarget = getNextWeekday(prague("2027-03-26T16:00"));
  assert.equal(toPragueDateKey(fridayTarget), "2027-03-29");
  assert.ok(holidays.has(toPragueDateKey(fridayTarget)));

  const mondayTarget = getNextWeekday(prague("2027-03-29T16:00"));
  assert.equal(toPragueDateKey(mondayTarget), "2027-03-30");
  assert.ok(!holidays.has(toPragueDateKey(mondayTarget)));
});

test("box return ordered before Christmas lands on Monday", () => {
  const date = getNextWorkingDay(holidays, prague("2026-12-23T12:00"));
  assert.equal(toPragueDateKey(date), "2026-12-28");
});

test("removed holiday becomes a working day again", () => {
  const withoutChristmasEve = new Set(holidays);
  withoutChristmasEve.delete("2026-12-24");

  const target = getNextWeekday(prague("2026-12-23T16:00"));
  assert.equal(toPragueDateKey(target), "2026-12-24");
  assert.ok(!withoutChristmasEve.has(toPragueDateKey(target)));
  assert.equal(
    toPragueDateKey(getNextWorkingDay(withoutChristmasEve, prague("2026-12-23T12:00"))),
    "2026-12-24",
  );
});

test("Friday donation target is Monday", () => {
  const target = getNextWeekday(prague("2026-10-23T16:00"));
  assert.equal(toPragueDateKey(target), "2026-10-26");
});

test("box return ordered over the weekend lands on Monday", () => {
  const empty = new Set();
  assert.equal(toPragueDateKey(getNextWorkingDay(empty, prague("2026-10-24T10:00"))), "2026-10-26");
  assert.equal(toPragueDateKey(getNextWorkingDay(empty, prague("2026-10-25T10:00"))), "2026-10-26");
});

test("returned date is midnight Prague time", () => {
  const date = getNextWorkingDay(new Set(), prague("2026-10-27T16:00"));
  const local = DateTime.fromJSDate(date).setZone("Europe/Prague");
  assert.equal(local.toISO(), "2026-10-28T00:00:00.000+01:00");
});

test("just after midnight Prague time uses the Prague date, not UTC", () => {
  const from = prague("2026-12-23T00:30");
  assert.equal(from.toISOString().slice(0, 10), "2026-12-22");

  assert.equal(toPragueDateKey(from), "2026-12-23");
  assert.equal(toPragueDateKey(getNextWeekday(from)), "2026-12-24");
  assert.equal(toPragueDateKey(getNextWorkingDay(holidays, from)), "2026-12-28");
});
