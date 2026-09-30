import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/Button";
import { Plus } from "lucide-react";
import { APP_STRINGS } from "@/constants";

export function MedicalResultsHeader({
  openCreate,
  role,
  filterValue,
  setFilterValue,
  searchQuery,
  setSearchQuery,
}: {
  openCreate: () => void;
  role: string;
  filterValue: string;
  setFilterValue: (val: string) => void;
  searchQuery: string;
  setSearchQuery: (val: string) => void;
}) {
  return (
    <>
      <PageHeader
        title={APP_STRINGS.medicalResults.pageTitle}
        description={APP_STRINGS.medicalResults.pageSubtitle}
        action={
          <div title={role === "admin" ? APP_STRINGS.common.clinicalOnly : undefined}>
            <Button onClick={openCreate} icon={<Plus size={16} className="sm:w-[18px] sm:h-[18px]" />} disabled={role === "admin"}>
              <span className="sm:hidden">{APP_STRINGS.common.add}</span>
              <span className="hidden sm:inline">{APP_STRINGS.medicalResults.addBtn}</span>
            </Button>
          </div>
        }
      />
      <div className="flex justify-end mb-4 gap-2">
        <FilterDropdown
          value={filterValue}
          onChange={setFilterValue}
          options={[
            { label: 'Terbaru', value: 'newest' },
            { label: 'Terlama', value: 'oldest' },
          ]}
          placeholder={APP_STRINGS.common.searchSort}
        />
        <SearchFilterBar value={searchQuery} onChange={setSearchQuery} />
      </div>
    </>
  );
}
