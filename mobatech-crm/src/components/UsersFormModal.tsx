"use client";
import { useState, useEffect } from "react";
import { User } from "@/types/api";
import { APP_STRINGS } from "@/constants";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";
import { FormValidators } from "@/lib/validators";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { PhoneInput } from "@/components/ui/PhoneInput";
import { ImageUpload } from "@/components/ImageUpload";
import { Eye, EyeOff } from "lucide-react";


interface UsersFormModalProps {
  isOpen: boolean; onClose: () => void; user: Partial<User> | null; onSuccess: () => void;
  setToast: (t: {isOpen: boolean, message: string, type: 'success' | 'error'}) => void;
}

function useUsersForm(isOpen: boolean, user: Partial<User> | null, onClose: () => void, onSuccess: () => void, setToast: (t: {isOpen: boolean, message: string, type: 'success' | 'error'}) => void) {
  const queryClient = useQueryClient();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("+62");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [role, setRole] = useState("patient");
  const [imageUrl, setImageUrl] = useState("");
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (isOpen) {
      setFullName(user?.full_name || ""); setEmail(user?.email || ""); setPhone(user?.phone_number || "+62");
      setPassword(""); setRole(user?.role || "patient"); setImageUrl(user?.image_url || ""); setErrors({});
    }
  }, [user, isOpen]);

  const validate = (): boolean => {
    const e: Record<string, string> = {};
    const nameErr = FormValidators.name(fullName); if (nameErr) e.fullName = nameErr;
    const emailErr = FormValidators.email(email); if (emailErr) e.email = emailErr;
    const phoneErr = FormValidators.phone(phone); if (phoneErr) e.phone = phoneErr;
    if (!user && !password.trim()) e.password = "Kata sandi wajib diisi untuk pengguna baru.";
    setErrors(e); return Object.keys(e).length === 0;
  };

  const userMutation = useMutation({
    mutationFn: (payload: Record<string, string>) => {
      if (user?.id) return adminService.updateUser(user.id, payload);
      return adminService.createUser(payload);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: user?.id ? APP_STRINGS.common.userUpdateSuccess : APP_STRINGS.common.userCreateSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["users"] });
      onSuccess();
      onClose();
    },
    onError: (err: unknown) => {
      setToast({ isOpen: true, message: err instanceof Error ? err.message : "Kesalahan server", type: "error" });
    }
  });

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault(); if (!validate()) return;
    const payload = { full_name: fullName, email, phone_number: phone, password, role, image_url: imageUrl };
    userMutation.mutate(payload);
  };

  return { fullName, setFullName, email, setEmail, phone, setPhone, password, setPassword, showPassword, setShowPassword, role, setRole, imageUrl, setImageUrl, saving: userMutation.isPending, errors, handleSave };
}

function UsersBasicInputs({ fullName, setFullName, email, setEmail, phone, setPhone, saving, errors }: { fullName: string; setFullName: (v: string) => void; email: string; setEmail: (v: string) => void; phone: string; setPhone: (v: string) => void; saving: boolean; errors: Record<string, string> }) {
  return (
    <>
      <div>
        <label className="block text-xs font-semibold mb-2">Nama Lengkap</label>
        <input disabled={saving} type="text" required value={fullName} onChange={(e) => setFullName(e.target.value)} className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all ${errors.fullName ? "border-error" : ""}`} placeholder={APP_STRINGS.users.namePlaceholder} />
        {errors.fullName && <p className="text-xs text-error mt-1">{errors.fullName}</p>}
      </div>
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold mb-2">Email</label>
          <input disabled={saving} type="text" required value={email} onChange={(e) => setEmail(e.target.value)} className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all ${errors.email ? "border-error" : ""}`} placeholder={APP_STRINGS.users.emailPlaceholder} />
          {errors.email && <p className="text-xs text-error mt-1">{errors.email}</p>}
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">No. HP</label>
          <PhoneInput disabled={saving} value={phone} onChange={setPhone} className={errors.phone ? "border-error" : ""} />
          {errors.phone && <p className="text-xs text-error mt-1">{errors.phone}</p>}
        </div>
      </div>
    </>
  );
}

function UsersRolePassInputs({ role, setRole, password, setPassword, showPassword, setShowPassword, saving, errors, isEdit }: { role: string; setRole: (v: string) => void; password: string; setPassword: (v: string) => void; showPassword: boolean; setShowPassword: (v: boolean) => void; saving: boolean; errors: Record<string, string>; isEdit: boolean }) {
  return (
    <div className="grid grid-cols-2 gap-4">
      <div>
        <label className="block text-xs font-semibold mb-2">Peran (Role)</label>
        <select disabled={saving} required value={role} onChange={(e) => setRole(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground cursor-pointer focus:border-primary outline-none">
          <option value="patient">Pasien (Patient)</option> <option value="doctor">Dokter (Doctor)</option> <option value="pharmacist">Apoteker (Pharmacist)</option> <option value="admin">Admin</option>
        </select>
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">Kata Sandi {isEdit && "(Opsional)"}</label>
        <div className="relative">
          <input disabled={saving} type={showPassword ? "text" : "password"} required={!isEdit} value={password} onChange={(e) => setPassword(e.target.value)} className={`w-full h-10 px-3 pr-10 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all ${errors.password ? "border-error" : ""}`} placeholder={isEdit ? APP_STRINGS.users.passEditPlaceholder : APP_STRINGS.users.passNewPlaceholder} />
          <button type="button" tabIndex={-1} onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-foreground/50 hover:text-foreground transition-colors">
            {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
          </button>
        </div>
        {errors.password && <p className="text-xs text-error mt-1">{errors.password}</p>}
      </div>
    </div>
  );
}

// Migrated to React Query
export function UsersFormModal({ isOpen, onClose, user, onSuccess, setToast }: UsersFormModalProps) {
  const form = useUsersForm(isOpen, user, onClose, onSuccess, setToast);
  return (
    <Modal isOpen={isOpen} onClose={onClose} title={user ? "Edit Pengguna" : "Tambah Pengguna Baru"}>
      <form onSubmit={form.handleSave} className="space-y-4">
        <UsersBasicInputs fullName={form.fullName} setFullName={form.setFullName} email={form.email} setEmail={form.setEmail} phone={form.phone} setPhone={form.setPhone} saving={form.saving} errors={form.errors} />
        <UsersRolePassInputs role={form.role} setRole={form.setRole} password={form.password} setPassword={form.setPassword} showPassword={form.showPassword} setShowPassword={form.setShowPassword} saving={form.saving} errors={form.errors} isEdit={Boolean(user?.id)} />
        <ImageUpload imageUrl={form.imageUrl} setImageUrl={form.setImageUrl} label="Foto Profil" />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" onClick={onClose}>Batal</Button>
          <Button type="submit" isLoading={form.saving}>Simpan</Button>
        </div>
      </form>
    </Modal>
  );
}
