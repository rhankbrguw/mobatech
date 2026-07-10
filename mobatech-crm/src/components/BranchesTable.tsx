import React from "react";
import { Branch } from "@/types/api";
import { APP_STRINGS } from "@/lib/constants";
import { Card } from "@/components/ui/Card";
import { Edit, Trash2, MapPin, Eye, Inbox } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { SkeletonTable } from "@/components/ui/SkeletonTable";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

export function BranchesTable({
  items,
  loading,
  openForm,
  setDeleteId,
  onViewDetails,
}: {
  items: Branch[];
  loading: boolean;
  openForm: (item: Branch) => void;
  setDeleteId: (id: number) => void;
  onViewDetails?: (item: Branch) => void;
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
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.branches.tableHeaderName}</th>
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.branches.tableHeaderAddress}</th>
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.branches.tableHeaderGmaps}</th>
                <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.branches.tableHeaderActions}</th>
              </tr>
            </thead>
            <tbody>
              {items.length === 0 ? (
                <tr>
                  <td colSpan={4} className={`${TD_CLASS} text-center py-16`}>
                    <div className="flex flex-col items-center justify-center text-foreground/50">
                      <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                      <p className="text-sm font-normal">Data tidak ditemukan</p>
                    </div>
                  </td>
                </tr>
              ) : items.map((item) => (
                <tr key={item.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    <div className="flex items-center justify-center gap-3">
                      <img src={item.image_url} alt={item.name} className="w-8 h-8 rounded-full object-cover bg-glass-panel" />
                      {item.name}
                    </div>
                  </td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground max-w-xs truncate`}>{item.address}</td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    {item.gmaps_link ? (
                      <a href={item.gmaps_link} target="_blank" rel="noreferrer" className="text-primary hover:underline flex items-center justify-center gap-1">
                        <MapPin size={14} /> Buka Maps
                      </a>
                    ) : (
                      <span className="text-foreground/40 text-xs font-normal">Belum ada</span>
                    )}
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
                            onClick: () => openForm(item),
                          },
                          {
                            label: "Hapus",
                            icon: <Trash2 size={14} />,
                            onClick: () => setDeleteId(item.id),
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
