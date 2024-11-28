import { selectRandomNonCenter, middleThird } from 'color-perception/utils';
import { module, test } from 'qunit';

module('middleThird', function () {
  test('it works', function (assert) {
    const arr = (s: number, e: number) => [...middleThird(s, e).values()];
    // Starting at 0
    assert.deepEqual(arr(0, 13), [4, 5, 6, 7, 8]);
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
      [0, 13],
      [0, 2],
      [0, 3],
      [2, 11],
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
