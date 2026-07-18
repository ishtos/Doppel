// Worker unit tests. Run with: node --test  (no dependencies; uses node:test).
import { test } from 'node:test';
import assert from 'node:assert/strict';

import { validateProgress } from '../src/index.js';

const valid = {
  userId: 'default',
  currentStreak: 3,
  longestStreak: 9,
  totalPracticeMinutes: 120,
  completedLessons: 40,
  lastPracticeDate: '2026-07-18T00:00:00.000Z',
};

test('validateProgress accepts a well-formed snapshot', () => {
  assert.equal(validateProgress(valid), true);
});

test('validateProgress rejects non-objects', () => {
  for (const bad of [null, undefined, [], 'x', 42, true]) {
    assert.equal(validateProgress(bad), false);
  }
});

test('validateProgress rejects missing / wrong-typed counters', () => {
  assert.equal(validateProgress({ ...valid, currentStreak: undefined }), false);
  assert.equal(validateProgress({ ...valid, completedLessons: '5' }), false);
  assert.equal(validateProgress({ ...valid, totalPracticeMinutes: 1.5 }), false);
});

test('validateProgress rejects negative or absurd counters', () => {
  assert.equal(validateProgress({ ...valid, currentStreak: -1 }), false);
  assert.equal(validateProgress({ ...valid, completedLessons: 1e12 }), false);
});

test('validateProgress rejects bad userId / date fields', () => {
  assert.equal(validateProgress({ ...valid, userId: 123 }), false);
  assert.equal(validateProgress({ ...valid, userId: 'x'.repeat(200) }), false);
  assert.equal(validateProgress({ ...valid, lastPracticeDate: 12345 }), false);
  assert.equal(validateProgress({ ...valid, lastPracticeDate: 'x'.repeat(50) }), false);
});
