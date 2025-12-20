import { createContext, useContext, useState, useEffect } from "react";

type AuthUser = Record<string, any> | null;

type AuthContextValue = {
  user: AuthUser;
  loading: boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  register: (userData: Record<string, any>) => Promise<{ success: boolean; error?: string }>;
  logout: () => void;
  refreshUser: (tokenOverride?: string | null) => Promise<AuthUser>;
  isAuthenticated: boolean;
};

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthUser>(null);
  const [loading, setLoading] = useState(true);
  const API_URL = import.meta.env.VITE_API_URL || "http://localhost:5000";

  const fetchCurrentUser = async (token: string) => {
    const response = await fetch(`${API_URL}/api/v1/users/me`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error("Unable to load profile");
    }
    return response.json();
  };

  const refreshUser = async (tokenOverride?: string | null) => {
    const token = tokenOverride || localStorage.getItem("token");
    if (!token) {
      localStorage.removeItem("user");
      setUser(null);
      return null;
    }
    const profile = await fetchCurrentUser(token);
    localStorage.setItem("user", JSON.stringify(profile));
    setUser(profile);
    return profile;
  };

  // Check if user is logged in on mount
  useEffect(() => {
    const token = localStorage.getItem("token");
    const userData = localStorage.getItem("user");

    if (token && userData) {
      setUser(JSON.parse(userData));
    }
    const hydrate = async () => {
      if (!token) {
        setLoading(false);
        return;
      }
      try {
        await refreshUser(token);
      } catch (error) {
        localStorage.removeItem("token");
        localStorage.removeItem("user");
        setUser(null);
      } finally {
        setLoading(false);
      }
    };
    hydrate();
  }, []);

  const login = async (email: string, password: string) => {
    try {
      const response = await fetch(`${API_URL}/api/v1/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || error.message || "Login failed");
      }

      const data = await response.json();
      localStorage.setItem("token", data.access_token);
      await refreshUser(data.access_token);

      return { success: true };
    } catch (error) {
      const message = error instanceof Error ? error.message : "Login failed";
      return { success: false, error: message };
    }
  };

  const register = async (userData: Record<string, any>) => {
    try {
      // Register endpoint expects: first_name, last_name, email, password
      const registerData = {
        first_name: userData.firstName,
        last_name: userData.lastName,
        email: userData.email,
        password: userData.password,
      };

      const response = await fetch(`${API_URL}/api/v1/users/`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(registerData),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || error.message || "Registration failed");
      }

      const data = await response.json();
      // Response: { "id": "...", "message": "User registered successfully." }

      // After registration, log the user in
      return await login(userData.email, userData.password);
    } catch (error) {
      const message = error instanceof Error ? error.message : "Registration failed";
      return { success: false, error: message };
    }
  };

  const logout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    setUser(null);
  };

  const value = {
    user,
    loading,
    login,
    register,
    logout,
    refreshUser,
    isAuthenticated: !!user,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
