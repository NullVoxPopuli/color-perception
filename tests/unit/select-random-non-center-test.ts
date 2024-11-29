import {
  selectRandomNonCenter,
  middleThird,
  opposing,
} from 'color-perception/utils';
import { module, test } from 'qunit';

module('opposing', function () {
  test('it works', function (assert) {
    // 0, 1, [2], 3, 4
    assert.strictEqual(opposing(0, 4, 1), 3);
    assert.strictEqual(opposing(0, 4, 3), 1);

    // 10, 11, [12], 13, 14
    assert.strictEqual(opposing(10, 14, 11), 13);
    assert.strictEqual(opposing(10, 14, 13), 11);

    // 2, 3, [4, 5], 6, 7
    assert.strictEqual(opposing(2, 7, 3), 6);
    assert.strictEqual(opposing(2, 7, 6), 3);
    assert.strictEqual(opposing(2, 7, 4), 5);
    assert.strictEqual(opposing(2, 7, 5), 4);
    assert.strictEqual(opposing(2, 7, 2), 7);
    assert.strictEqual(opposing(2, 7, 7), 2);
  });
});

module('middleThird', function () {
  test('it works', function (assert) {
    const arr = (s: number, e: number) => [...middleThird(s, e).values()];
    // Starting at 0
    assert.deepEqual(arr(0, 13), [4, 5, 6, 7, 8]);
    assert.deepEqual(arr(0, 14), [5, 6, 7, 8, 9]);
    assert.deepEqual(arr(0, 2), [1]);
    assert.deepEqual(arr(0, 3), [1]);

    // Starting at 2
    assert.deepEqual(arr(2, 4), [3]);
    assert.deepEqual(arr(2, 6), [3, 4]);
    assert.deepEqual(arr(2, 7), [4, 5]);
    assert.deepEqual(arr(2, 11), [5, 6, 7]);

    // Starting at 10
    assert.deepEqual(arr(10, 23), [14, 15, 16, 17, 18]);
    assert.deepEqual(arr(10, 12), [11]);
    assert.deepEqual(arr(10, 13), [11]);
  });
});

module('selectRandomNonCenter()', function () {
  (
    [
      // [0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11, 12, 13, 14]
      [0, 14],
      // [0], [1], [2]
      [0, 2],
      // [0], [1, 2], [3]
      [0, 3],
      // [2, 3, 4], [5, 6, 7], [8, 9, 10]
      [2, 10],
    ] as Array<[number, number]>
  ).forEach((range) => {
    const neverEmit = middleThird(...range);
    const neverValues = [...neverEmit.values()];
    const neverList = neverValues.join(', ');

    test(`range, ${range.join(',')}, never selects the middle`, function (assert) {
      const doIt = () => selectRandomNonCenter(...range);

      for (let i = 0; i < 100; i++) {
        const value = doIt();

        assert.ok(
          !neverEmit.has(value),
          `Value, ${String(value)}, is not ${neverList}`
        );
      }
    });
  });
});
