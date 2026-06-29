"use client";

import { useState, useEffect } from "react";
import { User } from "@/types/api";
import { api, ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { ImageUpload } from "@/components/ImageUpload";

export function UsersFormModal({ isOpen, onClose, user, onSuccess, setToast }: { isOpen: boolean; onClose: () => void; user: Partial<User> | null; onSuccess: () => void; setToast: (t: any) => void; }) {
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("patient");
  const [imageUrl, setImageUrl] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    setFullName(user?.full_name || "");
    setEmail(user?.email || "");
    setPhone(user?.phone_number || "");
    setPassword("");
    setRole(user?.role || "patient");
    setImageUrl(user?.image_url || "");
  }, [user, isOpen]);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    const payload = { full_name: fullName, email, phone_number: phone, password, role, image_url: imageUrl };
    try {
      if (user?.id) {
        await api.put(`/api/admin/users/${user.id}`, payload);
        setToast({ isOpen: true, message: "Pengguna diperbarui", type: "success" });
      } else {
        await api.post("/api/admin/users", payload);
        setToast({ isOpen: true, message: "Pengguna ditambahkan", type: "success" });
      }
      onSuccess();
      onClose();
    } catch (err) {
      setToast({ isOpen: true, message: err instanceof ApiError ? err.message : "Kesalahan server", type: "error" });
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={user ? "Edit Pengguna" : "Tambah Pengguna Baru"}>
      <form onSubmit={handleSave} className="space-y-4">
        <div>
          <label className="block text-xs font-semibold mb-2">Nama Lengkap</label>
          <input disabled={saving} type="text" required value={fullName} onChange={(e) => setFullName(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={APP_STRINGS.users.namePlaceholder} />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold mb-2">Email</label>
            <input disabled={saving} type="email" required value={email} onChange={(e) => setEmail(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={APP_STRINGS.users.emailPlaceholder} />
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">No. HP</label>
            <input disabled={saving} type="text" required value={phone} onChange={(e) => setPhone(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={APP_STRINGS.users.phonePlaceholder} />
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold mb-2">Peran (Role)</label>
            <select disabled={saving} required value={role} onChange={(e) => setRole(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground cursor-pointer focus:border-primary outline-none">
              <option value="patient">Pasien (Patient)</option>
              <option value="doctor">Dokter (Doctor)</option>
              <option value="pharmacist">Apoteker (Pharmacist)</option>
              <option value="admin">Admin</option>
            </select>
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">Kata Sandi {user && "(Opsional)"}</label>
            <input disabled={saving} type="password" required={!user} value={password} onChange={(e) => setPassword(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={user ? APP_STRINGS.users.passEditPlaceholder : APP_STRINGS.users.passNewPlaceholder} />
          </div>
        </div>
        <ImageUpload imageUrl={imageUrl} setImageUrl={setImageUrl} label="Foto Profil" />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" onClick={onClose}>Batal</Button>
          <Button type="submit" isLoading={saving}>Simpan</Button>
        </div>
      </form>
    </Modal>
  );
}
