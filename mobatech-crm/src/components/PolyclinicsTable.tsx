import { Badge } from "@/components/ui/Badge";
import { Card } from "@/components/ui/Card";
import { Edit, Trash2, Eye, Inbox } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { SkeletonTable } from "@/components/ui/SkeletonTable";
import { Polyclinic } from "@/types/api";
import { APP_STRINGS } from "@/lib/constants";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

export function PolyclinicsTable({
  items,
  loading,
  onEdit,
  onDelete,
  onViewDetails
}: {
  items: Polyclinic[];
  loading: boolean;
  onEdit: (item: Polyclinic) => void;
  onDelete: (id: number) => void;
  onViewDetails?: (item: Polyclinic) => void;
}) {
  return (
    <Card noPadding>
      <div className="w-full overflow-x-auto">
        {loading ? (
          <SkeletonTable rows={5} columns={4} />
        ) : (
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.polyclinics.tableHeaderName}</th>
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.polyclinics.tableHeaderDesc}</th>
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.polyclinics.tableHeaderStatus}</th>
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.polyclinics.tableHeaderActions}</th>
              </tr>
            </thead>
            <tbody>
              {items.length === 0 ? (
                <tr>
                  <td colSpan={100} className="text-center py-16">
                    <div className="flex flex-col items-center justify-center text-foreground/50">
                      <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                      <p className="text-sm">Data tidak ditemukan</p>
                    </div>
                  </td>
                </tr>
              ) : items.map((item) => (
                <tr key={item.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>{item.name}</td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground truncate max-w-xs`}>{item.description}</td>

                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    <Badge variant={item.is_active ? "success" : "error"}>
                      {item.is_active ? APP_STRINGS.polyclinics.statusActive : APP_STRINGS.polyclinics.statusInactive}
                    </Badge>
                  </td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    <div className="flex justify-center">
                      <ActionMenu
                        items={[
                          ...(onViewDetails ? [{
                            label: "Lihat Detail",
                            icon: <Eye size={14} />,
                            onClick: () => onViewDetails(item),
                          }] : []),
                          {
                            label: "Ubah",
                            icon: <Edit size={14} />,
                            onClick: () => onEdit(item),
                          },
                          {
                            label: "Hapus",
                            icon: <Trash2 size={14} />,
                            onClick: () => onDelete(item.id),
                            variant: "danger" as const,
                          }
                        ]}
                      />
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </Card>
  );
}

