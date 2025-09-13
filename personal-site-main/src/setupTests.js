// eslint-disable-next-line import/no-extraneous-dependencies
import '@testing-library/jest-dom';

// Mock dynamic import function
const originalImport = global.import;
global.import = jest.fn((modulePath) => {
  if (modulePath.includes('.md')) {
    return Promise.resolve({
      default: 'data:text/markdown,# Mock About Content\n\nThis is mock markdown content for testing purposes.',
    });  }
  return originalImport ? originalImport(modulePath) : Promise.reject(new Error(`Module ${modulePath} not found`));
});
