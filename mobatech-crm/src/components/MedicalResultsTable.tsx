import { Inbox } from "lucide-react";
import { Card } from "@/components/ui/Card";
import { SkeletonTable } from "@/components/ui/SkeletonTable";
import { User, MedicalResult } from "@/types/api";
import { MedicalResultsTableHeader } from "./medical-results/MedicalResultsTableHeader";
import { MedicalResultsTableRow } from "./medical-results/MedicalResultsTableRow";

export function MedicalResultsTable({ 
  loading, 
  results, 
  users, 
  onEdit, 
  onDelete,
  onViewDetails,
  onCreatePrescription,
  userRole 
}: { 
  loading: boolean;
  results: MedicalResult[];
  users: User[];
  onEdit: (r: MedicalResult) => void;
  onDelete: (id: number) => void;
  onViewDetails?: (r: MedicalResult) => void;
  onCreatePrescription?: (r: MedicalResult) => void;
  userRole?: string;
}) {
  return (
    <Card noPadding>
      <div className="w-full overflow-x-auto">
        {loading ? (
          <SkeletonTable rows={5} columns={6} />
        ) : (
          <table className="w-full border-collapse text-sm">
            <MedicalResultsTableHeader />
            <tbody>
              {results.length === 0 ? (
                <tr>
                  <td colSpan={6} className="text-center py-16">
                    <div className="flex flex-col items-center justify-center text-foreground/50">
                      <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                      <p className="text-sm">Belum ada data hasil medis.</p>
                    </div>
                  </td>
                </tr>
              ) : results.map((r) => (
                <MedicalResultsTableRow
                  key={r.id}
                  result={r}
                  users={users}
                  userRole={userRole}
                  onEdit={onEdit}
                  onDelete={onDelete}
                  onViewDetails={onViewDetails}
                  onCreatePrescription={onCreatePrescription}
                />
              ))}
            </tbody>
          </table>
        )}
      </div>
    </Card>
  );
}
