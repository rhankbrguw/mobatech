import { SideDrawer } from "@/components/ui/SideDrawer";
import { Formatters } from "@/lib/formatters";
import { APP_STRINGS } from "@/lib/constants";
import { User } from "@/types/api";

export function UserDetailView({
  isOpen,
  onClose,
  user,
}: {
  isOpen: boolean;
  onClose: () => void;
  user: User | null;
}) {
  if (!user) return null;

  return (
    <SideDrawer isOpen={isOpen} onClose={onClose} title={APP_STRINGS.details.userTitle}>
      <div className="space-y-4">
        <div className="flex items-center gap-4">
          <img src={user.image_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.full_name)}&background=1e5e44&color=fff`} alt={user.full_name} className="w-16 h-16 rounded-full border border-glass-border object-cover" />
          <div>
            <h3 className="text-lg font-bold">{user.full_name}</h3>
            <span className={`inline-flex items-center gap-1 px-2 py-0.5 mt-1 rounded text-[10px] font-semibold uppercase ${user.role === "admin" ? "bg-error-muted text-error" : user.role === "doctor" ? "bg-info-muted text-info" : user.role === "pharmacist" ? "bg-warning-muted text-warning" : "bg-success-muted text-success"}`}>{user.role}</span>
          </div>
        </div>
        <div className="grid grid-cols-1 gap-2 pt-2 border-t border-glass-border/50">
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.email}</span><span className="text-sm font-medium">{user.email}</span></div>
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.phone}</span><span className="text-sm font-medium">{Formatters.phone(user.phone_number)}</span></div>
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.dob}</span><span className="text-sm font-medium">{user.date_of_birth ? Formatters.date(user.date_of_birth) : "-"}</span></div>
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.gender}</span><span className="text-sm font-medium capitalize">{user.gender || "-"}</span></div>
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.bloodType}</span><span className="text-sm font-medium">{user.blood_type || "-"}</span></div>
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.heightWeight}</span><span className="text-sm font-medium">{user.height || 0} cm / {user.weight || 0} kg</span></div>
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.allergies}</span><span className="text-sm font-medium text-error">{user.allergies || APP_STRINGS.details.noAllergies}</span></div>
          <div className="flex flex-col"><span className="text-xs text-foreground/50">{APP_STRINGS.details.registeredAt}</span><span className="text-sm font-medium">{Formatters.date(user.created_at, "datetime")}</span></div>
        </div>
      </div>
    </SideDrawer>
  );
}
