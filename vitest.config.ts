// Copyright © 2026 Christopher Snow

// The platform's own tests, under Vitest.
//
// The lesson schema runs under Node with no DOM: nothing in it may touch a browser, and running
// it here is what enforces that. The runtime's and the primitives' component tests opt into a DOM
// with a `// @vitest-environment jsdom` comment at the top of the file. A book's own tests, and
// the browser-level educational tests, live in the book's repository.
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["packages/**/*.test.ts", "packages/**/*.test.tsx"],
    environment: "node",
    setupFiles: ["./tests/vitest.setup.ts"],
    passWithNoTests: false,
  },
});
