import Image from "next/image";
import { User } from "@/types/api";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { Badge } from "@/components/ui/Badge";
import { Formatters } from "@/lib/formatters";
import { Mail, Phone, ShieldCheck, User as UserIcon } from "lucide-react";
import { APP_STRINGS } from "@/constants";

interface PharmacistDetailDrawerProps {
  isOpen: boolean;
  onClose: () => void;
  pharmacist: User | null;
}

export function PharmacistDetailDrawer({
  isOpen,
  onClose,
  pharmacist,
}: PharmacistDetailDrawerProps) {
  if (!pharmacist) return null;

  const avatar = pharmacist.image_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(pharmacist.full_name)}&background=113C2B&color=fff`;
  const id = pharmacist.id || (pharmacist as { ID?: number }).ID || 0;

  return (
    <SideDrawer isOpen={isOpen} onClose={onClose} title={APP_STRINGS.details.pharmacistTitle}>
      <div className="space-y-6">
        <div className="flex flex-col items-center text-center p-4 rounded-2xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
          <Image unoptimized width={80} height={80} src={avatar} alt={pharmacist.full_name} className="w-20 h-20 rounded-full object-cover border-2 border-primary shadow-md mb-3" />
          <h3 className="text-lg font-bold text-foreground">{pharmacist.full_name}</h3>
          <p className="text-xs text-foreground/60 mb-2">ID Pengguna: {id}</p>
          <Badge variant="warning">{APP_STRINGS.details.registeredPharmacist}</Badge>
        </div>

        <div className="space-y-3">
          <h4 className="text-xs font-bold uppercase tracking-wider text-foreground/50">{APP_STRINGS.details.contactAccountSection}</h4>
          <div className="space-y-2 text-xs">
            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Mail size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">Alamat Email</div>
                <div className="font-semibold text-foreground">{pharmacist.email}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Phone size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">Nomor Telepon</div>
                <div className="font-semibold text-foreground">{Formatters.phone(pharmacist.phone_number)}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <ShieldCheck size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">Hak Akses Portal</div>
                <div className="font-semibold text-foreground">Apotek & Validasi Resep Medis</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <UserIcon size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">Waktu Pendaftaran</div>
                <div className="font-semibold text-foreground">{pharmacist.created_at ? new Date(pharmacist.created_at).toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' }) : "-"}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </SideDrawer>
  );
}
