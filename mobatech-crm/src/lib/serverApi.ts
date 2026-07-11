import { cookies } from "next/headers";

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080";

export async function serverFetch<T>(path: string, options: RequestInit = {}): Promise<T> {
  const cookieStore = await cookies();
  const token = cookieStore.get("auth_token")?.value;

  const headers = new Headers(options.headers);
  headers.set("Content-Type", "application/json");
  if (token) {
    headers.set("Authorization", `Bearer ${token}`);
  }

  const res = await fetch(`${API_BASE_URL}${path}`, {
    ...options,
    headers,
  });

  if (!res.ok) {
    const errorData = await res.json().catch(() => ({}));
    throw new Error(errorData.message || "An error occurred while fetching data");
  }

  const normalizeKeys = (obj: unknown): unknown => {
    if (Array.isArray(obj)) return obj.map(normalizeKeys);
    else if (obj !== null && typeof obj === "object") {
      const newObj: Record<string, unknown> = {};
      for (const key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
          let newKey = key;
          if (key === "ID") newKey = "id";
          else if (key === "CreatedAt") newKey = "created_at";
          else if (key === "UpdatedAt") newKey = "updated_at";
          else if (key === "DeletedAt") newKey = "deleted_at";
          newObj[newKey] = normalizeKeys((obj as Record<string, unknown>)[key]);
        }
      }
      return newObj;
    }
    return obj;
  };

  const json = await res.json();
  return normalizeKeys(json.data) as T;
}
