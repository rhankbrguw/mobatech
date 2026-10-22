const ENCRYPTION_KEY = process.env.ENCRYPTION_KEY || "";

async function getCryptoKey(secret: string): Promise<CryptoKey> {
  if (!ENCRYPTION_KEY) throw new Error("ENCRYPTION_KEY is required in environment variables");
  const enc = new TextEncoder();
  const keyHash = await crypto.subtle.digest("SHA-256", enc.encode(secret));
  return crypto.subtle.importKey(
    "raw",
    keyHash,
    { name: "AES-GCM" },
    false,
    ["encrypt", "decrypt"]
  );
}

export async function encryptData(text: string): Promise<string> {
  try {
    const cryptoKey = await getCryptoKey(ENCRYPTION_KEY);
    const iv = crypto.getRandomValues(new Uint8Array(12));
    const enc = new TextEncoder();
    const encrypted = await crypto.subtle.encrypt(
      { name: "AES-GCM", iv },
      cryptoKey,
      enc.encode(text)
    );
    
    const combined = new Uint8Array(iv.length + encrypted.byteLength);
    combined.set(iv);
    combined.set(new Uint8Array(encrypted), iv.length);
    
    return btoa(Array.from(combined).map(b => String.fromCharCode(b)).join(""));
  } catch (error) {
    throw new Error(`SECURE_ENCRYPTION_FAILED: ${error instanceof Error ? error.message : String(error)}`);
  }
}

export async function decryptData(encryptedText: string): Promise<string> {
  try {
    const cryptoKey = await getCryptoKey(ENCRYPTION_KEY);
    const combined = new Uint8Array(
      atob(encryptedText).split("").map(c => c.charCodeAt(0))
    );
    
    const iv = combined.slice(0, 12);
    const ciphertext = combined.slice(12);
    
    const decrypted = await crypto.subtle.decrypt(
      { name: "AES-GCM", iv },
      cryptoKey,
      ciphertext
    );
    
    return new TextDecoder().decode(decrypted);
  } catch {
    /* ignored */
    throw new Error("SECURE_DECRYPTION_FAILED");
  }
}
