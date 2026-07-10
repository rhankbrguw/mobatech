import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { APP_STRINGS } from "@/lib/constants";

export function EmergenciesHeader({
  filterValue,
  setFilterValue,
  searchQuery,
  setSearchQuery,
}: {
  filterValue: string;
  setFilterValue: (val: string) => void;
  searchQuery: string;
  setSearchQuery: (val: string) => void;
}) {
  return (
    <>
      <div className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight text-error dark:text-error flex items-center gap-2">
          <span className="w-2 h-2 rounded-full bg-error animate-ping"></span>
          Gawat Darurat
        </h1>
        <p className="text-foreground/60 text-sm mt-1">Live tracking panggilan darurat dan pengerahan ambulans.</p>
      </div>
      <div className="flex flex-col sm:flex-row justify-end gap-2 mb-4">
        <FilterDropdown
          value={filterValue}
          onChange={setFilterValue}
          options={[
            { label: 'Pending', value: 'pending' },
            { label: 'Direspon', value: 'responded' },
            { label: 'Selesai', value: 'resolved' },
          ]}
          placeholder={APP_STRINGS.common.searchStatus}
          className="w-full sm:w-48 h-11"
        />
        <SearchFilterBar value={searchQuery} onChange={setSearchQuery} className="w-full sm:max-w-xs h-11" />
      </div>
    </>
  );
}
