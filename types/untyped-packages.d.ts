declare module 'nearest-color' {
  interface NearestFn {
    (color: string): { name: string };
  }

  declare const nearestColor: { from: (colors: unknown) => NearestFn };

  export default nearestColor;
}

declare module 'color-name-list' {
  export const colornames: { name: string; hex: string }[];
}

declare module 'color-space' {
  declare const colorSpace: {
    rgb: {
      lchab(input: number[]): string;
      lchuv(input: number[]): string;
    };
  };

  export default colorSpace;
}
