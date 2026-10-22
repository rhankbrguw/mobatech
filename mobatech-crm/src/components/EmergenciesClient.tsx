"use client";
import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { useState, useEffect } from "react";
import { APP_STRINGS } from "@/constants";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { Card } from "@/components/ui/Card";
import { Pagination } from "@/components/ui/Pagination";
import { EmergenciesHeader } from "./EmergenciesHeader";
import { EmergenciesTable } from "./EmergenciesTable";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";

export function EmergenciesClient({ initialData: _initialData, searchParams: _searchParams }: { initialData?: unknown, searchParams?: Record<string, string | string[] | undefined> }) {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";
  const queryClient = useQueryClient();

  const [searchQuery, setSearchQuery] = useState("");
  const [filterValue, setFilterValue] = useState("");
  const [currentPage, setCurrentPage] = useState(1);

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning";
  }>({ isOpen: false, message: "", type: "success" });

  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery, filterValue]);

  const queryParams = new URLSearchParams();
  if (searchQuery) queryParams.append("search", searchQuery);
  if (filterValue) queryParams.append("filter", filterValue);
  queryParams.append("page", String(currentPage));
  queryParams.append("limit", "10");
  const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";

  const { data, isLoading: loading } = useQuery({
    queryKey: ["emergencies", qs],
    queryFn: async () => {
      const res = await adminService.getEmergenciesList(qs);
      return res;
    },
    refetchInterval: 10000,
  });

  const items = data?.data || [];
  const totalPages = data?.meta?.total_pages || 1;

  const updateMutation = useMutation({
    mutationFn: async ({ id, status }: { id: number; status: string }) => {
      await adminService.updateEmergencyStatus(id, status);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.updateSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["emergencies"] });
    },
    onError: (err: Error) => {
      const msg = err.message || APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    },
  });

  const updateStatus = (id: number, status: string) => {
    updateMutation.mutate({ id, status });
  };

  if (!["admin"].includes(role)) {
    return <ForbiddenView />;
  }
  return (
    <div className="space-y-6 animate-slide-in">
      <EmergenciesHeader
        filterValue={filterValue}
        setFilterValue={setFilterValue}
        searchQuery={searchQuery}
        setSearchQuery={setSearchQuery}
      />

      <Card noPadding>
        <div className="w-full overflow-x-auto">
          <EmergenciesTable items={items} loading={loading} updateStatus={updateStatus} />
        </div>
      </Card>
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />

      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
