import { useAuthStore } from "@/store/useAuthStore";

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080";

export interface ApiResponse<T = any> {
  success: boolean;
  code: string;
  message: string;
  data: T;
}

export class ApiError extends Error {
  code: string;
  status: number;
  errors?: any;

  constructor(code: string, status: number, message: string, errors?: any) {
    super(message);
    this.code = code;
    this.status = status;
    this.errors = errors;
    this.name = "ApiError";
  }
}

function getErrorCode(status: number): string {
  switch (status) {
    case 401: return "UNAUTHENTICATED";
    case 403: return "UNAUTHORIZED";
    case 404: return "NOT_FOUND";
    case 409: return "CONFLICT";
    case 422: return "VALIDATION_ERROR";
    default: return "INTERNAL_ERROR";
  }
}

function normalizeKeys(obj: any): any {
  if (Array.isArray(obj)) {
    return obj.map(normalizeKeys);
  } else if (obj !== null && typeof obj === "object") {
    const newObj: any = {};
    for (const key in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, key)) {
        let newKey = key;
        if (key === "ID") newKey = "id";
        else if (key === "CreatedAt") newKey = "created_at";
        else if (key === "UpdatedAt") newKey = "updated_at";
        else if (key === "DeletedAt") newKey = "deleted_at";
        newObj[newKey] = normalizeKeys(obj[key]);
      }
    }
    return newObj;
  }
  return obj;
}

async function request<T>(
  path: string,
  options: RequestInit = {}
): Promise<ApiResponse<T>> {
  // Use lazy loading for auth store to avoid circular imports during startup
  const token = useAuthStore.getState().token;
  
  const headers = new Headers(options.headers);
  headers.set("Content-Type", "application/json");
  if (token) {
    headers.set("Authorization", `Bearer ${token}`);
  }
  
  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...options,
    headers,
  });
  
  const rawData = await response.json().catch(() => ({}));
  const data = normalizeKeys(rawData);
  
  if (!response.ok) {
    const errorCode = data.code || getErrorCode(response.status);
    const errorMessage = data.message || "Terjadi kesalahan koneksi.";
    throw new ApiError(errorCode, response.status, errorMessage, data.errors);
  }
  
  return data as ApiResponse<T>;
}

export const api = {
  get: <T>(path: string, options?: RequestInit) => 
    request<T>(path, { ...options, method: "GET" }),
    
  post: <T>(path: string, body: any, options?: RequestInit) => 
    request<T>(path, {
      ...options,
      method: "POST",
      body: JSON.stringify(body),
    }),
    
  put: <T>(path: string, body: any, options?: RequestInit) => 
    request<T>(path, {
      ...options,
      method: "PUT",
      body: JSON.stringify(body),
    }),
    
  delete: <T>(path: string, options?: RequestInit) => 
    request<T>(path, { ...options, method: "DELETE" }),
};
