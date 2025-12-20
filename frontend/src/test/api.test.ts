import { describe, it, expect, beforeEach, vi, afterEach } from 'vitest';

// Mock API functions - adjust these based on your actual API file structure
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

// Simple API client functions for testing
async function fetchPlaces() {
  const response = await fetch(`${API_BASE_URL}/api/v1/places/`);
  if (!response.ok) throw new Error('Failed to fetch places');
  return response.json();
}

async function fetchPlaceById(id: string) {
  const response = await fetch(`${API_BASE_URL}/api/v1/places/${id}`);
  if (!response.ok) throw new Error('Place not found');
  return response.json();
}

async function createBooking(bookingData: any) {
  const token = localStorage.getItem('token');
  const response = await fetch(`${API_BASE_URL}/api/v1/bookings/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(bookingData),
  });
  if (!response.ok) throw new Error('Failed to create booking');
  return response.json();
}

describe('API Utility Functions', () => {
  beforeEach(() => {
    global.fetch = vi.fn();
    localStorage.clear();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  describe('fetchPlaces', () => {
    it('fetches places successfully', async () => {
      const mockPlaces = [
        { id: '1', title: 'Villa 1', price: 200 },
        { id: '2', title: 'Villa 2', price: 300 },
      ];

      global.fetch.mockResolvedValueOnce({
        ok: true,
        json: async () => mockPlaces,
      });

      const result = await fetchPlaces();

      expect(global.fetch).toHaveBeenCalledWith(
        expect.stringContaining('/api/v1/places/')
      );
      expect(result).toEqual(mockPlaces);
    });

    it('throws error on failed fetch', async () => {
      global.fetch.mockResolvedValueOnce({
        ok: false,
        status: 500,
      });

      await expect(fetchPlaces()).rejects.toThrow('Failed to fetch places');
    });
  });

  describe('fetchPlaceById', () => {
    it('fetches single place by ID', async () => {
      const mockPlace = { id: '123', title: 'Luxury Villa', price: 500 };

      global.fetch.mockResolvedValueOnce({
        ok: true,
        json: async () => mockPlace,
      });

      const result = await fetchPlaceById('123');

      expect(global.fetch).toHaveBeenCalledWith(
        expect.stringContaining('/api/v1/places/123')
      );
      expect(result).toEqual(mockPlace);
    });

    it('throws error for non-existent place', async () => {
      global.fetch.mockResolvedValueOnce({
        ok: false,
        status: 404,
      });

      await expect(fetchPlaceById('999')).rejects.toThrow('Place not found');
    });
  });

  describe('createBooking', () => {
    it('creates booking with authentication', async () => {
      const mockBooking = {
        place_id: '123',
        check_in_date: '2025-12-20',
        check_out_date: '2025-12-25',
        total_price: 2500,
      };

      const mockResponse = {
        id: 'booking-123',
        ...mockBooking,
        status: 'confirmed',
      };

      localStorage.setItem('token', 'fake-jwt-token');

      global.fetch.mockResolvedValueOnce({
        ok: true,
        json: async () => mockResponse,
      });

      const result = await createBooking(mockBooking);

      expect(global.fetch).toHaveBeenCalledWith(
        expect.stringContaining('/api/v1/bookings/'),
        expect.objectContaining({
          method: 'POST',
          headers: expect.objectContaining({
            Authorization: 'Bearer fake-jwt-token',
          }),
        })
      );
      expect(result).toEqual(mockResponse);
    });

    it('includes auth token in request headers', async () => {
      localStorage.setItem('token', 'test-token-123');

      global.fetch.mockResolvedValueOnce({
        ok: true,
        json: async () => ({}),
      });

      await createBooking({ place_id: '123' });

      const callArgs = global.fetch.mock.calls[0][1];
      expect(callArgs.headers.Authorization).toBe('Bearer test-token-123');
    });

    it('throws error on failed booking creation', async () => {
      localStorage.setItem('token', 'fake-token');

      global.fetch.mockResolvedValueOnce({
        ok: false,
        status: 400,
      });

      await expect(
        createBooking({ place_id: '123' })
      ).rejects.toThrow('Failed to create booking');
    });
  });

  describe('API error handling', () => {
    it('handles network errors', async () => {
      global.fetch.mockRejectedValueOnce(new Error('Network error'));

      await expect(fetchPlaces()).rejects.toThrow('Network error');
    });

    it('handles timeout errors', async () => {
      global.fetch.mockImplementation(
        () => new Promise((_, reject) =>
          setTimeout(() => reject(new Error('Timeout')), 100)
        )
      );

      await expect(fetchPlaces()).rejects.toThrow('Timeout');
    });
  });
});
