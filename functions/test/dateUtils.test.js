const { test } = require("node:test");
const assert = require("node:assert/strict");
const { DateTime } = require("luxon");
const {
  getDonationTargetDay,
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

/** Returns the donation target key, or null when no deliveries are created. */
function donationTarget(nonWorkingDays, isoLocal) {
  const target = getDonationTargetDay(nonWorkingDays, prague(isoLocal));
  return target && toPragueDateKey(target);
}

test("donation run creates nothing for a mid-week holiday", () => {
  assert.equal(donationTarget(holidays, "2026-10-27T16:00"), null);
  assert.equal(donationTarget(holidays, "2026-10-28T16:00"), "2026-10-29");
});

test("Easter skips Friday and Monday, Monday run creates Tuesday", () => {
  assert.equal(donationTarget(holidays, "2027-03-25T16:00"), null);
  assert.equal(donationTarget(holidays, "2027-03-26T16:00"), null);
  assert.equal(donationTarget(holidays, "2027-03-29T16:00"), "2027-03-30");
});

test("box return ordered before Christmas lands on Monday", () => {
  const date = getNextWorkingDay(holidays, prague("2026-12-23T12:00"));
  assert.equal(toPragueDateKey(date), "2026-12-28");
});

test("removed holiday becomes a working day again", () => {
  const withoutChristmasEve = new Set(holidays);
  withoutChristmasEve.delete("2026-12-24");

  assert.equal(donationTarget(holidays, "2026-12-23T16:00"), null);
  assert.equal(donationTarget(withoutChristmasEve, "2026-12-23T16:00"), "2026-12-24");
  assert.equal(
    toPragueDateKey(getNextWorkingDay(withoutChristmasEve, prague("2026-12-23T12:00"))),
    "2026-12-24",
  );
});

test("Friday donation target is Monday", () => {
  assert.equal(donationTarget(new Set(), "2026-10-23T16:00"), "2026-10-26");
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
  assert.equal(getDonationTargetDay(holidays, from), null);
  assert.equal(toPragueDateKey(getNextWorkingDay(holidays, from)), "2026-12-28");
});
