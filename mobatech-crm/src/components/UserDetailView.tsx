import Image from "next/image";
import { User } from "@/types/api";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { Badge, BadgeVariant } from "@/components/ui/Badge";
import { Formatters } from "@/lib/formatters";
import {
  LucideIcon,
  Mail,
  Phone,
  ShieldCheck,
  User as UserIcon,
  Droplet,
  Activity,
  AlertCircle,
} from "lucide-react";
import { APP_STRINGS } from "@/constants";

interface UserDetailViewProps {
  isOpen: boolean;
  onClose: () => void;
  user: User | null;
}

const roleBadgeMap: Record<string, { variant: BadgeVariant; label: string }> = {
  admin: { variant: "error", label: "Administrator" },
  doctor: { variant: "info", label: "Dokter Spesialis" },
  pharmacist: { variant: "warning", label: "Apoteker" },
  patient: { variant: "success", label: "Pasien Terdaftar" },
};

function InfoRow({
  icon: Icon,
  label,
  value,
  valueClass = "text-foreground",
}: {
  icon: LucideIcon;
  label: string;
  value: string;
  valueClass?: string;
}) {
  return (
    <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
      <Icon size={16} className="text-primary shrink-0" />
      <div>
        <div className="text-foreground/50 text-[11px]">{label}</div>
        <div className={`font-semibold text-xs ${valueClass}`}>{value}</div>
      </div>
    </div>
  );
}

export function UserDetailView({ isOpen, onClose, user }: UserDetailViewProps) {
  if (!user) return null;

  const avatar =
    user.image_url ||
    `https://ui-avatars.com/api/?name=${encodeURIComponent(user.full_name)}&background=113C2B&color=fff`;
  const id = user.id || (user as { ID?: number }).ID || 0;
  const roleMeta = roleBadgeMap[user.role] || {
    variant: "neutral" as BadgeVariant,
    label: user.role,
  };

  return (
    <SideDrawer isOpen={isOpen} onClose={onClose} title={APP_STRINGS.details.userTitle}>
      <div className="space-y-6">
        <div className="flex flex-col items-center text-center p-4 rounded-2xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
          <Image
            unoptimized
            width={80}
            height={80}
            src={avatar}
            alt={user.full_name}
            className="w-20 h-20 rounded-full object-cover border-2 border-primary shadow-md mb-3"
          />
          <h3 className="text-lg font-bold text-foreground">{user.full_name}</h3>
          <p className="text-xs text-foreground/60 mb-2">ID Pengguna: {id}</p>
          <Badge variant={roleMeta.variant}>{roleMeta.label}</Badge>
        </div>

        <div className="space-y-3">
          <h4 className="text-xs font-bold uppercase tracking-wider text-foreground/50">
            {APP_STRINGS.details.contactAccountSection}
          </h4>
          <div className="space-y-2 text-xs">
            <InfoRow icon={Mail} label={APP_STRINGS.details.email} value={user.email} />
            <InfoRow icon={Phone} label={APP_STRINGS.details.phone} value={Formatters.phone(user.phone_number)} />
            <InfoRow icon={ShieldCheck} label="Peran Akun" value={roleMeta.label} />
            <InfoRow
              icon={UserIcon}
              label={APP_STRINGS.details.registeredAt}
              value={user.created_at ? Formatters.date(user.created_at, "datetime") : "-"}
            />
          </div>
        </div>

        {(user.blood_type || user.date_of_birth || user.allergies || user.height || user.weight) && (
          <div className="space-y-3">
            <h4 className="text-xs font-bold uppercase tracking-wider text-foreground/50">
              Informasi Medis & Fisik
            </h4>
            <div className="space-y-2 text-xs">
              {user.blood_type && (
                <InfoRow icon={Droplet} label={APP_STRINGS.details.bloodType} value={user.blood_type} />
              )}
              {(user.height || user.weight) && (
                <InfoRow
                  icon={Activity}
                  label={APP_STRINGS.details.heightWeight}
                  value={`${user.height || 0} cm / ${user.weight || 0} kg`}
                />
              )}
              {user.allergies && (
                <InfoRow
                  icon={AlertCircle}
                  label={APP_STRINGS.details.allergies}
                  value={user.allergies}
                  valueClass="text-error"
                />
              )}
            </div>
          </div>
        )}
      </div>
    </SideDrawer>
  );
}
