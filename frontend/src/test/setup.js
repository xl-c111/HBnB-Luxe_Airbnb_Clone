import '@testing-library/jest-dom';

// Mock localStorage with actual storage
const storage = {};
const localStorageMock = {
  getItem: vi.fn((key) => storage[key] || null),
  setItem: vi.fn((key, value) => {
    storage[key] = value.toString();
  }),
  removeItem: vi.fn((key) => {
    delete storage[key];
  }),
  clear: vi.fn(() => {
    Object.keys(storage).forEach(key => delete storage[key]);
  }),
};

global.localStorage = localStorageMock;

// Mock import.meta.env
global.import = { meta: { env: { VITE_API_URL: 'http://localhost:5000' } } };
